import Foundation
import SwiftData

@Model
final class RoutineCompletion {
    var date: Date
    var dateString: String
    var isCompleted: Bool
    var completionTimestamp: Date?
    var task: RoutineTask?
    
    init(date: Date, isCompleted: Bool = false, completionTimestamp: Date? = nil, task: RoutineTask? = nil) {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        
        self.isCompleted = isCompleted
        self.completionTimestamp = completionTimestamp
        self.task = task
    }
}
