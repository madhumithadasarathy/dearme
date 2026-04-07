import Foundation
import UserNotifications
import SwiftData

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var permissionGranted = false
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.permissionGranted = granted
                completion(granted)
            }
        }
    }
    
    func scheduleAllNotifications(context: ModelContext) {
        guard permissionGranted else { return }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        scheduleSugarAlerts()
        scheduleRoutines(context: context)
        schedulePeriodAlerts(context: context)
        scheduleWellness()
    }
    
    private func scheduleSugarAlerts() {
        let timesAndMessages = [
            (8, 0, "Before-breakfast sugar check time 🩷"),
            (10, 0, "Hey love, time for your after-breakfast check ✨"),
            (12, 0, "Before-lunch sugar check time 🎀"),
            (14, 0, "Quick check-in: after-lunch checking 💌"),
            (19, 0, "Before-dinner sugar check time 💕"),
            (21, 0, "After-dinner check, you're doing great 💗")
        ]
        
        for (hour, minute, message) in timesAndMessages {
            scheduleDaily(hour: hour, minute: minute, title: "Sugar Log", body: message, identifier: "sugar_\(hour)_\(minute)")
        }
    }
    
    private func scheduleRoutines(context: ModelContext) {
        let descriptor = FetchDescriptor<RoutineTask>()
        guard let tasks = try? context.fetch(descriptor) else { return }
        
        for task in tasks {
            guard task.isEnabled else { continue }
            
            if task.title.contains("8 AM") {
                scheduleDaily(hour: 8, minute: 0, title: "Morning Routine", body: "Wake up love! A beautiful day awaits ✨", identifier: "routine_\(task.title)")
            } else if task.category == "Skincare Routine" && task.title == "Cleanser" {
                scheduleDaily(hour: 8, minute: 30, title: "Skincare", body: "Hey love, skincare time ✨", identifier: "routine_\(task.title)")
            } else if task.category == "Night Routine" && task.title.contains("Wind down") {
                scheduleDaily(hour: 21, minute: 45, title: "Wind Down", body: "Let's wind down now, okay? 🌙", identifier: "routine_\(task.title)")
            } else if let reminder = task.reminderTime {
                let currentCal = Calendar.current
                let hour = currentCal.component(.hour, from: reminder)
                let minute = currentCal.component(.minute, from: reminder)
                scheduleDaily(hour: hour, minute: minute, title: task.title, body: "One tiny step now, you've got this 💗", identifier: "routine_custom_\(task.title)")
            }
        }
    }
    
    private func schedulePeriodAlerts(context: ModelContext) {
        let descriptor = FetchDescriptor<PeriodTracking>()
        guard let tracks = try? context.fetch(descriptor), let track = tracks.first else { return }
        
        let cycleEnd = track.predictedNextCycleDate
        
        if let alert3 = Calendar.current.date(byAdding: .day, value: -3, to: cycleEnd) {
            scheduleOnDate(date: alert3, hour: 10, title: "Cycle Update", body: "Your cycle may be due in 3 days 🌷 Stay hydrated!", identifier: "period_3")
        }
        
        if let alert1 = Calendar.current.date(byAdding: .day, value: -1, to: cycleEnd) {
            scheduleOnDate(date: alert1, hour: 10, title: "Wellness", body: "Go gentle on yourself today 💗 Cycle expected tomorrow.", identifier: "period_1")
        }
        
        scheduleOnDate(date: cycleEnd, hour: 10, title: "Cycle Day 1", body: "Listen to your body today. Take it easy 🌸", identifier: "period_0")
    }
    
    private func scheduleWellness() {
        scheduleDaily(hour: 15, minute: 0, title: "Hydration", body: "Don't forget to sip some water, deeply breathe in and out 💧", identifier: "wellness_water")
        scheduleDaily(hour: 21, minute: 30, title: "Journal", body: "How was your day? Ready to write a little? 📝", identifier: "wellness_journal")
    }
    
    private func scheduleDaily(hour: Int, minute: Int, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleOnDate(date: Date, hour: Int, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
