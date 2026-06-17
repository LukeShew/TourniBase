import SwiftUI

@main
struct TourniBaseApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .tint(.tbBlue)
        }
    }
}
