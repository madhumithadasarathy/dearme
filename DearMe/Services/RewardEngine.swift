import SwiftData
import SwiftUI

class RewardEngine {
    static let shared = RewardEngine()
    
    func fetchProgress(context: ModelContext) -> RewardsProgress {
        let descriptor = FetchDescriptor<RewardsProgress>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        } else {
            let newProgress = RewardsProgress()
            context.insert(newProgress)
            return newProgress
        }
    }
    
    func addPoints(context: ModelContext, amount: Int) {
        let progress = fetchProgress(context: context)
        progress.totalPoints += amount
        if progress.totalPoints < 0 { progress.totalPoints = 0 }
        
        checkAchievements(progress: progress)
    }
    
    func evaluateSugarBonus(context: ModelContext, dateString: String) {
        let descriptor = FetchDescriptor<SugarEntry>()
        guard let entries = try? context.fetch(descriptor) else { return }
        
        let todaysEntries = entries.filter { $0.dateString == dateString }
        if todaysEntries.count >= 6 {
            let progress = fetchProgress(context: context)
            if !progress.completedRewards.contains("Sugar_Bonus_\(dateString)") {
                progress.totalPoints += 35
                progress.completedRewards.append("Sugar_Bonus_\(dateString)")
                checkAchievements(progress: progress)
            }
        }
    }
    
    func checkAchievements(progress: RewardsProgress) {
        let milestones = [
            (100, "Centurion"),
            (500, "High Achiever"),
            (1000, "Unstoppable")
        ]
        
        for milestone in milestones {
            if progress.totalPoints >= milestone.0 && !progress.achievementBadges.contains(milestone.1) {
                progress.achievementBadges.append(milestone.1)
            }
        }
    }
    
    func redeemReward(context: ModelContext, title: String, cost: Int) -> Bool {
        let progress = fetchProgress(context: context)
        if progress.totalPoints >= cost {
            progress.totalPoints -= cost
            progress.completedRewards.append(title)
            return true
        }
        return false
    }
}
