import SwiftUI

struct MoodCalendarView: View {
    let entries: [JournalEntry]
    
    var recentDates: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var dates: [String] = []
        for i in (0..<14).reversed() {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                dates.append(formatter.string(from: date))
            }
        }
        return dates
    }
    
    func entryFor(dateStr: String) -> JournalEntry? {
        return entries.first(where: { $0.dateString == dateStr })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Trends")
                .headingFont(size: 20)
                .foregroundColor(Color.Theme.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recentDates, id: \.self) { dateStr in
                        VStack {
                            Text(dateStr.suffix(2))
                                .font(.caption2)
                                .foregroundColor(Color.Theme.textSecondary)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(entryFor(dateStr: dateStr)?.moodColor ?? Color.gray.opacity(0.1))
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
        }
    }
}
