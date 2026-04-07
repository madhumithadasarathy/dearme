import Foundation
import SwiftData

@Model
final class RewardsProgress {
    var totalPoints: Int
    var currentStreak: Int
    var longestStreak: Int
    var completedRewards: [String]
    var achievementBadges: [String]
    
    init(totalPoints: Int = 0, currentStreak: Int = 0, longestStreak: Int = 0, completedRewards: [String] = [], achievementBadges: [String] = []) {
        self.totalPoints = totalPoints
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.completedRewards = completedRewards
        self.achievementBadges = achievementBadges
    }
}

