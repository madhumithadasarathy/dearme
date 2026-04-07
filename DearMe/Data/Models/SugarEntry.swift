import Foundation
import SwiftData

enum SugarTimeSlot: String, Codable, CaseIterable {
    case beforeBreakfast = "Before Breakfast"
    case afterBreakfast = "After Breakfast"
    case beforeLunch = "Before Lunch"
    case afterLunch = "After Lunch"
    case beforeDinner = "Before Dinner"
    case afterDinner = "After Dinner"
}

@Model
final class SugarEntry {
    var date: Date
    var timeSlotRaw: String
    var glucoseValue: Int
    var notes: String?
    var tags: [String]?
    
    var timeSlot: SugarTimeSlot {
        get { SugarTimeSlot(rawValue: timeSlotRaw) ?? .beforeBreakfast }
        set { timeSlotRaw = newValue.rawValue }
    }
    
    var colorBand: String {
        if glucoseValue < 70 { return "Critical Low" }
        else if glucoseValue <= 110 { return "Normal" }
        else if glucoseValue <= 199 { return "Moderate" }
        else { return "High" }
    }
    
    init(date: Date, timeSlot: SugarTimeSlot, glucoseValue: Int, notes: String? = nil, tags: [String]? = nil) {
        self.date = date
        self.timeSlotRaw = timeSlot.rawValue
        self.glucoseValue = glucoseValue
        self.notes = notes
        self.tags = tags
    }
}
