import SwiftUI

extension Color {
    static let tbBlue = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let tbNavy = Color(red: 15 / 255, green: 23 / 255, blue: 42 / 255)
    static let tbBackground = Color(red: 248 / 255, green: 250 / 255, blue: 252 / 255)
    static let tbBorder = Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)
    static let tbMuted = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let tbGreen = Color(red: 5 / 255, green: 150 / 255, blue: 105 / 255)
    static let tbOrange = Color(red: 234 / 255, green: 88 / 255, blue: 12 / 255)
}

extension EventAccent {
    var color: Color {
        switch self {
        case .blue: .tbBlue
        case .green: .tbGreen
        case .orange: .tbOrange
        case .violet: Color(red: 124 / 255, green: 58 / 255, blue: 237 / 255)
        }
    }
}

struct AppCardModifier: ViewModifier {
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.tbBorder, lineWidth: 1)
            }
    }
}

extension View {
    func appCard(padding: CGFloat = 16) -> some View {
        modifier(AppCardModifier(padding: padding))
    }

    func screenBackground() -> some View {
        background(Color.tbBackground.ignoresSafeArea())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.tbBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.tbNavy)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(configuration.isPressed ? Color.tbBorder.opacity(0.6) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.tbBorder, lineWidth: 1)
            }
    }
}
