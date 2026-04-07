import Foundation
import SwiftData

@Model
final class PeriodTracking {
    var lastPeriodStartDate: Date
    var cycleLength: Int
    var periodDuration: Int
    var symptoms: [String]?
    
    @Transient
    var predictedNextCycleDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: cycleLength, to: lastPeriodStartDate) ?? lastPeriodStartDate
    }
    
    init(lastPeriodStartDate: Date, cycleLength: Int = 26, periodDuration: Int = 5, symptoms: [String]? = nil) {
        self.lastPeriodStartDate = lastPeriodStartDate
        self.cycleLength = cycleLength
        self.periodDuration = periodDuration
        self.symptoms = symptoms
    }
}
