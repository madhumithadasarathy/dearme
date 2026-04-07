import SwiftUI

@main
struct DearMeApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light) // Soft, feminine aesthetics
        }
    }
}
