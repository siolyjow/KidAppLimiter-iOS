import Combine
import FamilyControls
import Foundation
import ManagedSettings

@MainActor
final class AppControlModel: ObservableObject {
    @Published var selection: FamilyActivitySelection {
        didSet {
            saveSelection()
            refreshSummary()
            if isShieldEnabled {
                applyShield()
            }
        }
    }

    @Published var isShieldEnabled: Bool {
        didSet {
            defaults.set(isShieldEnabled, forKey: Keys.isShieldEnabled)
            applyShield()
        }
    }

    @Published var authorizationMode: AuthorizationMode {
        didSet {
            defaults.set(authorizationMode.rawValue, forKey: Keys.authorizationMode)
        }
    }

    @Published private(set) var authorizationStatus: AuthorizationStatus
    @Published private(set) var summary: SelectionSummary
    @Published var errorMessage: String?

    private enum Keys {
        static let selection = "familyActivitySelection"
        static let isShieldEnabled = "isShieldEnabled"
        static let authorizationMode = "authorizationMode"
    }

    private let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        if let data = defaults.data(forKey: Keys.selection),
           let savedSelection = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            selection = savedSelection
        } else {
            selection = FamilyActivitySelection(includeEntireCategory: true)
        }

        if let rawMode = defaults.string(forKey: Keys.authorizationMode),
           let savedMode = AuthorizationMode(rawValue: rawMode) {
            authorizationMode = savedMode
        } else {
            authorizationMode = .child
        }

        isShieldEnabled = defaults.bool(forKey: Keys.isShieldEnabled)
        authorizationStatus = center.authorizationStatus
        summary = SelectionSummary(
            apps: selection.applicationTokens.count,
            categories: selection.categoryTokens.count,
            websites: selection.webDomainTokens.count
        )

        if isShieldEnabled {
            applyShield()
        }
    }

    var isAuthorized: Bool {
        authorizationStatus == .approved
    }

    func requestAuthorization() async {
        errorMessage = nil
        do {
            try await center.requestAuthorization(for: authorizationMode.member)
            authorizationStatus = center.authorizationStatus
        } catch {
            errorMessage = error.localizedDescription
            authorizationStatus = center.authorizationStatus
        }
    }

    func refreshAuthorizationStatus() {
        authorizationStatus = center.authorizationStatus
    }

    func applyShield() {
        guard isShieldEnabled else {
            store.clearAllSettings()
            return
        }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomainCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
    }

    func stopShielding() {
        isShieldEnabled = false
        store.clearAllSettings()
    }

    func clearSelection() {
        selection = FamilyActivitySelection(includeEntireCategory: true)
        stopShielding()
    }

    private func saveSelection() {
        guard let data = try? encoder.encode(selection) else {
            return
        }
        defaults.set(data, forKey: Keys.selection)
    }

    private func refreshSummary() {
        summary = SelectionSummary(
            apps: selection.applicationTokens.count,
            categories: selection.categoryTokens.count,
            websites: selection.webDomainTokens.count
        )
    }
}

