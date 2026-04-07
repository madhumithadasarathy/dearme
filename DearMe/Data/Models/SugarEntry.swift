import Foundation
import SwiftData
import SwiftUI

enum SugarTimeSlot: String, Codable, CaseIterable {
    case beforeBreakfast = "BB"
    case afterBreakfast = "AB"
    case beforeLunch = "BL"
    case afterLunch = "AL"
    case beforeDinner = "BD"
    case afterDinner = "AD"
    
    var fullName: String {
        switch self {
        case .beforeBreakfast: return "Before Breakfast"
        case .afterBreakfast: return "After Breakfast"
        case .beforeLunch: return "Before Lunch"
        case .afterLunch: return "After Lunch"
        case .beforeDinner: return "Before Dinner"
        case .afterDinner: return "After Dinner"
        }
    }
}

@Model
final class SugarEntry {
    var date: Date
    var dateString: String
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
    
    var statusColor: Color {
        if glucoseValue < 70 { return Color.Theme.critical }
        else if glucoseValue <= 110 { return Color.Theme.normalRange }
        else if glucoseValue <= 199 { return Color.Theme.moderate }
        else { return Color.Theme.critical.opacity(0.8) }
    }
    
    init(date: Date, timeSlot: SugarTimeSlot, glucoseValue: Int, notes: String? = nil, tags: [String]? = nil) {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        
        self.timeSlotRaw = timeSlot.rawValue
        self.glucoseValue = glucoseValue
        self.notes = notes
        self.tags = tags
    }
}
