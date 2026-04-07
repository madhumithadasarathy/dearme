import SwiftUI
import SwiftData

@main
struct DearMeApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
                    .preferredColorScheme(.light)
            } else {
                OnboardingView()
                    .preferredColorScheme(.light)
            }
        }
        .modelContainer(for: [
            UserProfile.self,
            RoutineTask.self,
            RoutineCompletion.self,
            SugarEntry.self,
            JournalEntry.self,
            PeriodTracking.self,
            RewardsProgress.self,
            MoodLog.self,
            ChatMessage.self
        ])
    }
}

