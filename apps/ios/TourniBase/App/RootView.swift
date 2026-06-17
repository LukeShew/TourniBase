import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                AppShellView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.hasCompletedOnboarding)
    }
}

struct AppShellView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.selectedTab) {
            ForEach(appState.selectedRole.tabs) { tab in
                NavigationStack {
                    tab.content(for: appState.selectedRole)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case events
    case passes
    case team
    case scan
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .events: "Events"
        case .passes: "Passes"
        case .team: "Team"
        case .scan: "Scan"
        case .profile: "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house.fill"
        case .events: "calendar"
        case .passes: "ticket.fill"
        case .team: "person.3.fill"
        case .scan: "qrcode.viewfinder"
        case .profile: "person.crop.circle"
        }
    }

    @ViewBuilder
    func content(for role: UserRole) -> some View {
        switch self {
        case .home:
            HomeView(role: role)
        case .events:
            EventsView(role: role)
        case .passes:
            PassesView()
        case .team:
            TeamView()
        case .scan:
            ScannerView()
        case .profile:
            ProfileView()
        }
    }
}
