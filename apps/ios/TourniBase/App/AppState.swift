import Foundation
import Observation

@MainActor
@Observable
final class AppState {
    var hasCompletedOnboarding = false
    var selectedRole: UserRole = .spectator
    var selectedTab: AppTab = .home
    var notificationsEnabled = true
    var passes = SampleData.passes
    var recentScans = SampleData.recentScans

    func completeOnboarding(as role: UserRole) {
        selectedRole = role
        selectedTab = role.defaultTab
        hasCompletedOnboarding = true
    }

    func switchRole(to role: UserRole) {
        selectedRole = role
        selectedTab = role.defaultTab
    }

    func addPass(_ pass: AdmissionPass) {
        passes.insert(pass, at: 0)
    }

    func addScan(result: ScanResult) {
        recentScans.insert(result, at: 0)
    }

    func resetDemo() {
        hasCompletedOnboarding = false
        selectedRole = .spectator
        selectedTab = .home
        passes = SampleData.passes
        recentScans = SampleData.recentScans
    }
}
