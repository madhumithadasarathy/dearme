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
    
    @Relationship(deleteRule: .cascade, inverse: \RoutineCompletion.task)
    var completions: [RoutineCompletion]?
    
    init(title: String, category: String, estimatedDurationMinutes: Int = 10, pointsValue: Int = 10, isEnabled: Bool = true, reminderTime: Date? = nil, isFlexible: Bool = true) {
        self.title = title
        self.category = category
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.pointsValue = pointsValue
        self.isEnabled = isEnabled
        self.reminderTime = reminderTime
        self.isFlexible = isFlexible
    }
}
