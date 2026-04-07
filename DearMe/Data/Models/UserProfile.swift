import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var wakeUpTime: Date
    var sleepTargetTime: Date
    var cycleLength: Int
    var themePreference: String
    var notificationsEnabled: Bool
    
    init(name: String = "User", 
         wakeUpTime: Date = Date(), 
         sleepTargetTime: Date = Date(), 
         cycleLength: Int = 26, 
         themePreference: String = "Light", 
         notificationsEnabled: Bool = true) {
        self.name = name
        self.wakeUpTime = wakeUpTime
        self.sleepTargetTime = sleepTargetTime
        self.cycleLength = cycleLength
        self.themePreference = themePreference
        self.notificationsEnabled = notificationsEnabled
    }
}
