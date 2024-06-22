import SwiftUI

@main
struct HMS_DOCTORApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @StateObject var viewModel : AppViewModel = AppViewModel()
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                LoginView()
                    .environmentObject(viewModel)
            } else {
                SplashScreen()
            }
        }
    }
}
