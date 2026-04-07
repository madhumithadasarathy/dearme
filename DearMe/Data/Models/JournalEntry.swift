import Foundation
import SwiftData

@Model
final class JournalEntry {
    var date: Date
    var title: String?
    var content: String
    var mood: String
    var tags: [String]?
    var isLowDay: Bool
    
    init(date: Date = Date(), title: String? = nil, content: String = "", mood: String = "Neutral", tags: [String]? = nil, isLowDay: Bool = false) {
        self.date = date
        self.title = title
        self.content = content
        self.mood = mood
        self.tags = tags
        self.isLowDay = isLowDay
    }
}
