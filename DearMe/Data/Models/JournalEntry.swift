import Foundation
import SwiftData
import SwiftUI

@Model
final class JournalEntry {
    var date: Date
    var dateString: String
    var title: String?
    var content: String
    var mood: String
    var tags: [String]?
    var isLowDay: Bool
    
    init(date: Date = Date(), title: String? = nil, content: String = "", mood: String = "Neutral", tags: [String]? = nil, isLowDay: Bool = false) {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        
        self.title = title
        self.content = content
        self.mood = mood
        self.tags = tags
        self.isLowDay = isLowDay
    }
    
    @Transient
    var moodColor: Color {
        switch mood {
        case "Happy": return Color.Theme.normalRange
        case "Calm": return Color.Theme.blushPink
        case "Neutral": return Color.gray.opacity(0.3)
        case "Anxious": return Color.Theme.moderate
        case "Sad": return Color.Theme.dustyRose
        case "Overwhelmed": return Color.Theme.critical
        default: return Color.gray.opacity(0.3)
        }
    }
}
