import SwiftUI

@main
struct KidAppLimiterApp: App {
    @StateObject private var model = AppControlModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}

