import Foundation
import SwiftData

@Model
final class RoutineTask {
    var title: String
    var category: String
    var estimatedDurationMinutes: Int
    var pointsValue: Int
    var isEnabled: Bool
    var reminderTime: Date?
    var isFlexible: Bool
    
    var timerDurationSeconds: Int?
    var activeModes: [String]
    var frequency: String
    
    @Relationship(deleteRule: .cascade, inverse: \RoutineCompletion.task)
    var completions: [RoutineCompletion]?
    
    init(title: String, category: String, estimatedDurationMinutes: Int = 10, pointsValue: Int = 10, isEnabled: Bool = true, reminderTime: Date? = nil, isFlexible: Bool = true, timerDurationSeconds: Int? = nil, activeModes: [String] = ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"], frequency: String = "Daily") {
        self.title = title
        self.category = category
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.pointsValue = pointsValue
        self.isEnabled = isEnabled
        self.reminderTime = reminderTime
        self.isFlexible = isFlexible
        self.timerDurationSeconds = timerDurationSeconds
        self.activeModes = activeModes
        self.frequency = frequency
    }
}
