import Foundation
import SwiftData

@Model
final class RoutineCompletion {
    var date: Date
    var isCompleted: Bool
    var completionTimestamp: Date?
    var task: RoutineTask?
    
    init(date: Date, isCompleted: Bool = false, completionTimestamp: Date? = nil, task: RoutineTask? = nil) {
        self.date = date
        self.isCompleted = isCompleted
        self.completionTimestamp = completionTimestamp
        self.task = task
    }
}
