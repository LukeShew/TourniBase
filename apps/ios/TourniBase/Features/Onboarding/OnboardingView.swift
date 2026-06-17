import SwiftUI
import UIKit

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var step = 0
    @State private var selectedRole: UserRole = .spectator
    @State private var email = "john.smith@example.com"
    @State private var name = "John Smith"

    var body: some View {
        ZStack {
            Color.tbBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    TourniBaseLogo(compact: true)
                    Spacer()
                    Text("\(step + 1) of 3")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.tbMuted)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ProgressView(value: Double(step + 1), total: 3)
                    .tint(.tbBlue)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                TabView(selection: $step) {
                    WelcomeStep()
                        .tag(0)
                    RoleStep(selectedRole: $selectedRole)
                        .tag(1)
                    AccountStep(email: $email, name: $name, role: selectedRole)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: step)

                VStack(spacing: 12) {
                    Button(step == 2 ? "Enter demo" : "Continue") {
                        if step < 2 {
                            step += 1
                        } else {
                            appState.completeOnboarding(as: selectedRole)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .accessibilityIdentifier("onboardingContinue")

                    if step > 0 {
                        Button("Back") {
                            step -= 1
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.tbMuted)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
    }
}

private struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.tbBlue.opacity(0.10))
                    .frame(width: 190, height: 190)

                Image(systemName: "ticket.fill")
                    .font(.system(size: 76, weight: .bold))
                    .foregroundStyle(Color.tbBlue)
                    .rotationEffect(.degrees(-12))
            }

            VStack(spacing: 12) {
                Text("Tournament entry,\nfinally in one place.")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.tbNavy)
                    .multilineTextAlignment(.center)

                Text("Buy passes, check in faster, and keep every tournament organized from one app.")
                    .font(.body)
                    .foregroundStyle(Color.tbMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14)
            }

            HStack(spacing: 22) {
                OnboardingBenefit(icon: "creditcard.fill", title: "One payment")
                OnboardingBenefit(icon: "qrcode", title: "Fast entry")
                OnboardingBenefit(icon: "chart.bar.fill", title: "Live insight")
            }

            Spacer()
        }
        .padding(24)
    }
}

private struct RoleStep: View {
    @Binding var selectedRole: UserRole

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ScreenHeader(
                    eyebrow: "Choose your view",
                    title: "How will you use TourniBase?",
                    subtitle: "The demo changes its tools and dashboard based on your role."
                )
                .padding(.bottom, 4)

                ForEach(UserRole.allCases) { role in
                    Button {
                        selectedRole = role
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: role.systemImage)
                                .font(.title2)
                                .foregroundStyle(selectedRole == role ? .white : Color.tbBlue)
                                .frame(width: 48, height: 48)
                                .background(selectedRole == role ? Color.tbBlue : Color.tbBlue.opacity(0.10))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(role.title)
                                    .font(.headline)
                                    .foregroundStyle(Color.tbNavy)
                                Text(role.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.tbMuted)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            Image(systemName: selectedRole == role ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(selectedRole == role ? Color.tbBlue : Color.tbBorder)
                        }
                        .appCard()
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("role-\(role.rawValue)")
                }
            }
            .padding(24)
        }
    }
}

private struct AccountStep: View {
    @Binding var email: String
    @Binding var name: String
    let role: UserRole

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                ScreenHeader(
                    eyebrow: "Demo account",
                    title: "Set up your profile.",
                    subtitle: "Nothing is submitted. These details only personalize the mockup."
                )

                VStack(spacing: 16) {
                    LabeledField(label: "Full name", text: $name, contentType: .name)
                    LabeledField(label: "Email", text: $email, contentType: .emailAddress)
                }
                .appCard()

                HStack(spacing: 12) {
                    Image(systemName: role.systemImage)
                        .font(.title3)
                        .foregroundStyle(Color.tbBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Starting as")
                            .font(.caption)
                            .foregroundStyle(Color.tbMuted)
                        Text(role.title)
                            .font(.headline)
                            .foregroundStyle(Color.tbNavy)
                    }
                    Spacer()
                    StatusPill(text: "Demo", color: .tbBlue)
                }
                .appCard()
            }
            .padding(24)
        }
    }
}

private struct OnboardingBenefit: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.tbBlue)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.tbNavy)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LabeledField: View {
    let label: String
    @Binding var text: String
    let contentType: UITextContentType

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.tbMuted)
            TextField(label, text: $text)
                .textContentType(contentType)
                .textInputAutocapitalization(contentType == .emailAddress ? .never : .words)
                .keyboardType(contentType == .emailAddress ? .emailAddress : .default)
                .padding(.horizontal, 12)
                .frame(height: 48)
                .background(Color.tbBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}
