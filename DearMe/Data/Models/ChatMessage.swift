import Foundation
import SwiftData

@Model
final class ChatMessage {
    var id: UUID
    var role: String
    var content: String
    var timestamp: Date
    
    init(role: String, content: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
