import FamilyControls
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: AppControlModel
    @State private var isPickerPresented = false

    var body: some View {
        NavigationStack {
            Form {
                authorizationSection
                selectionSection
                controlSection
                statusSection
            }
            .navigationTitle("轻用")
            .familyActivityPicker(
                title: "选择要管理的 App",
                headerText: "选择短视频、游戏或其他需要管理的 App。",
                footerText: "选择结果由系统以隐私令牌保存。",
                isPresented: $isPickerPresented,
                selection: $model.selection
            )
            .task {
                model.refreshAuthorizationStatus()
            }
        }
    }

    private var authorizationSection: some View {
        Section("授权") {
            Picker("授权类型", selection: $model.authorizationMode) {
                ForEach(AuthorizationMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }

            Button {
                Task {
                    await model.requestAuthorization()
                }
            } label: {
                Label(model.isAuthorized ? "已授权" : "请求授权", systemImage: model.isAuthorized ? "checkmark.seal.fill" : "person.badge.key")
            }
            .disabled(model.isAuthorized)
        }
    }

    private var selectionSection: some View {
        Section("管理对象") {
            HStack {
                Label("已选择", systemImage: "square.grid.2x2")
                Spacer()
                Text(model.summary.text)
                    .foregroundStyle(.secondary)
            }

            Button {
                isPickerPresented = true
            } label: {
                Label("选择 App / 网站", systemImage: "plus.circle")
            }

            if model.summary.total > 0 {
                Button(role: .destructive) {
                    model.clearSelection()
                } label: {
                    Label("清空选择", systemImage: "trash")
                }
            }
        }
    }

    private var controlSection: some View {
        Section("控制") {
            Toggle(isOn: $model.isShieldEnabled) {
                Label("启用屏蔽", systemImage: "shield.lefthalf.filled")
            }
            .disabled(!model.isAuthorized || model.summary.total == 0)

            Button {
                model.stopShielding()
            } label: {
                Label("恢复全部", systemImage: "lock.open")
            }
            .disabled(!model.isShieldEnabled)
        }
    }

    private var statusSection: some View {
        Section("状态") {
            Label(model.isAuthorized ? "系统授权可用" : "等待系统授权", systemImage: model.isAuthorized ? "checkmark.circle" : "exclamationmark.circle")
                .foregroundStyle(model.isAuthorized ? .green : .orange)

            Label(model.isShieldEnabled ? "屏蔽已启用" : "屏蔽未启用", systemImage: model.isShieldEnabled ? "shield.fill" : "shield")
                .foregroundStyle(model.isShieldEnabled ? .green : .secondary)

            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppControlModel())
}

