import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    
    @State private var showingEditor = false
    @State private var selectedEntry: JournalEntry? = nil
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    var todayEntry: JournalEntry? {
        entries.first(where: { $0.dateString == todayDateString })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Journal & Wellness")
                        
                        PlannerCard {
                            MoodCalendarView(entries: entries)
                        }
                        
                        PlannerCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(todayEntry == nil ? "Ready to reflect on today?" : "Today's Reflection")
                                    .headingFont(size: 20)
                                    .foregroundColor(Color.Theme.textPrimary)
                                
                                if let todayEntry = todayEntry {
                                    HStack {
                                        Text("Mood:")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Text(todayEntry.mood)
                                            .font(.caption).fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(todayEntry.moodColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                        
                                        if todayEntry.isLowDay {
                                            Text("Support Active")
                                                .font(.caption).fontWeight(.bold)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.Theme.critical)
                                                .foregroundColor(.white)
                                                .cornerRadius(6)
                                        }
                                    }
                                    
                                    if !todayEntry.content.isEmpty {
                                        Text(todayEntry.content)
                                            .bodyFont()
                                            .foregroundColor(Color.Theme.textSecondary)
                                            .lineLimit(3)
                                    }
                                }
                                
                                SoftButton(title: todayEntry == nil ? "Write Entry" : "Edit Entry") {
                                    selectedEntry = todayEntry
                                    showingEditor = true
                                }
                            }
                        }
                        
                        SectionHeader(title: "Past Entries")
                        ForEach(entries.filter { $0.dateString != todayDateString }) { entry in
                            PlannerCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(entry.dateString)
                                            .font(.caption).fontWeight(.bold)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Spacer()
                                        Circle()
                                            .fill(entry.moodColor)
                                            .frame(width: 12, height: 12)
                                    }
                                    Text(entry.content)
                                        .bodyFont()
                                        .lineLimit(2)
                                        .foregroundColor(Color.Theme.textPrimary)
                                }
                            }
                            .onTapGesture {
                                selectedEntry = entry
                                showingEditor = true
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditor) {
                JournalEditorView(existingEntry: selectedEntry)
            }
        }
    }
}

#Preview {
    JournalView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
