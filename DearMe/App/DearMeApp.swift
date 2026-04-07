import SwiftUI
import SwiftData

@main
struct DearMeApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light) // Soft, feminine aesthetics
        }
        .modelContainer(for: [
            UserProfile.self,
            RoutineTask.self,
            RoutineCompletion.self,
            SugarEntry.self,
            JournalEntry.self,
            PeriodTracking.self,
            RewardsProgress.self,
            MoodLog.self
        ])
    }
}

