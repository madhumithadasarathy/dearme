import Foundation
import SwiftData

@Model
final class MoodLog {
    var date: Date
    var moodLevel: Int // 1 to 5
    var energyLevel: Int
    var stressLevel: Int
    var notes: String?
    
    init(date: Date = Date(), moodLevel: Int = 3, energyLevel: Int = 3, stressLevel: Int = 3, notes: String? = nil) {
        self.date = date
        self.moodLevel = moodLevel
        self.energyLevel = energyLevel
        self.stressLevel = stressLevel
        self.notes = notes
    }
}
