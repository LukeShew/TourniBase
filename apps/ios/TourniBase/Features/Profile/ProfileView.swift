import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var showRolePicker = false
    @State private var showResetAlert = false

    var body: some View {
        @Bindable var appState = appState

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(
                    eyebrow: "Account",
                    title: "Profile",
                    subtitle: "Manage your demo account and switch between TourniBase roles."
                )

                ProfileCard(role: appState.selectedRole)

                VStack(spacing: 0) {
                    SettingsButton(icon: "arrow.triangle.2.circlepath", title: "Switch demo role", detail: appState.selectedRole.shortTitle) {
                        showRolePicker = true
                    }
                    Divider().padding(.leading, 54)
                    Toggle(isOn: $appState.notificationsEnabled) {
                        SettingsLabel(icon: "bell.fill", title: "Notifications", detail: "Event and entry updates")
                    }
                    .tint(.tbBlue)
                    .padding(15)
                    Divider().padding(.leading, 54)
                    SettingsButton(icon: "creditcard.fill", title: "Payment methods", detail: "Visa •••• 4242") {}
                    Divider().padding(.leading, 54)
                    SettingsButton(icon: "person.2.fill", title: "Family members", detail: "2 people") {}
                }
                .appCard(padding: 0)

                VStack(spacing: 0) {
                    SettingsButton(icon: "questionmark.circle.fill", title: "Help and support", detail: nil) {}
                    Divider().padding(.leading, 54)
                    SettingsButton(icon: "lock.shield.fill", title: "Privacy", detail: nil) {}
                    Divider().padding(.leading, 54)
                    SettingsButton(icon: "doc.text.fill", title: "Terms", detail: nil) {}
                }
                .appCard(padding: 0)

                Button {
                    showResetAlert = true
                } label: {
                    Label("Reset app demo", systemImage: "arrow.counterclockwise")
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(SecondaryButtonStyle())

                Text("TourniBase mockup • Version 0.1")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .sheet(isPresented: $showRolePicker) {
            RolePickerSheet()
        }
        .alert("Reset the mockup?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                appState.resetDemo()
            }
        } message: {
            Text("This returns to onboarding and restores the original sample data.")
        }
    }
}

private struct ProfileCard: View {
    let role: UserRole

    var body: some View {
        HStack(spacing: 15) {
            Text("JS")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
                .background(Color.tbBlue)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text("John Smith")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
                Text("john.smith@example.com")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                StatusPill(text: role.title, color: .tbBlue, systemImage: role.systemImage)
            }
            Spacer()
        }
        .appCard()
    }
}

private struct SettingsLabel: View {
    let icon: String
    let title: String
    let detail: String?

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .foregroundStyle(Color.tbBlue)
                .frame(width: 26)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.tbNavy)
                if let detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(Color.tbMuted)
                }
            }
        }
    }
}

private struct SettingsButton: View {
    let icon: String
    let title: String
    let detail: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                SettingsLabel(icon: icon, title: title, detail: detail)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.tbMuted)
            }
            .padding(15)
        }
        .buttonStyle(.plain)
    }
}

private struct RolePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ForEach(UserRole.allCases) { role in
                    Button {
                        appState.switchRole(to: role)
                        dismiss()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: role.systemImage)
                                .font(.title3)
                                .foregroundStyle(Color.tbBlue)
                                .frame(width: 44, height: 44)
                                .background(Color.tbBlue.opacity(0.10))
                                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(role.title)
                                    .font(.headline)
                                    .foregroundStyle(Color.tbNavy)
                                Text(role.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(Color.tbMuted)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Image(systemName: appState.selectedRole == role ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(appState.selectedRole == role ? Color.tbBlue : Color.tbBorder)
                        }
                        .appCard()
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(18)
            .background(Color.tbBackground)
            .navigationTitle("Switch role")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
