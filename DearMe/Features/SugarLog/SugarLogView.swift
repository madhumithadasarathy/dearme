import SwiftUI
import SwiftData

struct SugarLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SugarEntry.date, order: .reverse) private var entries: [SugarEntry]
    
    @State private var isEnteringData = false
    @State private var inputDate: Date = Date()
    @State private var inputSlot: SugarTimeSlot = .beforeBreakfast
    @State private var glucoseInput = ""
    @State private var notesInput = ""
    @State private var existingEntry: SugarEntry? = nil
    
    var groupedEntries: [(String, [SugarEntry])] {
        let dict = Dictionary(grouping: entries, by: { $0.dateString })
        let sortedKeys = dict.keys.sorted(by: >)
        return sortedKeys.map { ($0, dict[$0]!) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Logbook")
                    
                    // Grid Header
                    HStack(spacing: 8) {
                        Text("Date")
                            .font(.caption2).fontWeight(.bold)
                            .frame(width: 45, alignment: .leading)
                            .foregroundColor(Color.Theme.textSecondary)
                        ForEach(SugarTimeSlot.allCases, id: \.self) { slot in
                            Text(slot.rawValue)
                                .font(.caption2).fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.Theme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            let todayStr = todayDateString()
                            if !groupedEntries.contains(where: { $0.0 == todayStr }) {
                                SugarDayRow(dateString: todayStr, dayEntries: []) { slot in
                                    openEditor(forDate: Date(), slot: slot, existing: nil)
                                }
                            }
                            
                            ForEach(groupedEntries, id: \.0) { group in
                                SugarDayRow(dateString: group.0, dayEntries: group.1) { slot in
                                    let date = formatter.date(from: group.0) ?? Date()
                                    let entry = group.1.first(where: { $0.timeSlot == slot })
                                    openEditor(forDate: date, slot: slot, existing: entry)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isEnteringData) {
                SugarInputSheet(
                    date: inputDate,
                    slot: inputSlot,
                    glucoseInput: $glucoseInput,
                    notesInput: $notesInput,
                    onSave: saveEntry,
                    onCancel: { isEnteringData = false }
                )
            }
        }
    }
    
    var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    func todayDateString() -> String {
        return formatter.string(from: Date())
    }
    
    func openEditor(forDate date: Date, slot: SugarTimeSlot, existing: SugarEntry?) {
        inputDate = date
        inputSlot = slot
        existingEntry = existing
        if let e = existing {
            glucoseInput = "\(e.glucoseValue)"
            notesInput = e.notes ?? ""
        } else {
            glucoseInput = ""
            notesInput = ""
        }
        isEnteringData = true
    }
    
    func saveEntry() {
        guard let value = Int(glucoseInput) else { return }
        
        if let existing = existingEntry {
            existing.glucoseValue = value
            existing.notes = notesInput.isEmpty ? nil : notesInput
        } else {
            let newEntry = SugarEntry(date: inputDate, timeSlot: inputSlot, glucoseValue: value, notes: notesInput.isEmpty ? nil : notesInput)
            modelContext.insert(newEntry)
        }
        isEnteringData = false
    }
}

#Preview {
    SugarLogView()
        .modelContainer(for: SugarEntry.self, inMemory: true)
}
