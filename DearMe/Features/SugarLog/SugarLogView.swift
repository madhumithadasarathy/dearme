import SwiftUI
import SwiftData

struct SugarLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SugarEntry.date, order: .reverse) private var entries: [SugarEntry]

    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Sugar Log")
                        
                        if entries.isEmpty {
                            PlannerCard {
                                Text("No logs yet. Add your first reading!")
                                    .bodyFont()
                                    .foregroundColor(Color.Theme.textSecondary)
                            }
                        } else {
                            ForEach(entries) { entry in
                                PlannerCard {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("\(entry.glucoseValue) mg/dL")
                                                .bodyFont()
                                                .fontWeight(.bold)
                                                .foregroundColor(entry.glucoseValue > 199 || entry.glucoseValue < 70 ? Color.Theme.critical : Color.Theme.textPrimary)
                                            Text(entry.timeSlotRaw)
                                                .font(.caption)
                                                .foregroundColor(Color.Theme.textSecondary)
                                        }
                                        Spacer()
                                        Button(action: {
                                            deleteEntry(entry)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(Color.Theme.critical)
                                        }
                                    }
                                }
                            }
                        }
                        
                        SoftButton(title: "Add Sample Log") {
                            addSampleEntry()
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func addSampleEntry() {
        let newEntry = SugarEntry(date: Date(), timeSlot: .beforeBreakfast, glucoseValue: Int.random(in: 60...250))
        modelContext.insert(newEntry)
    }
    
    private func deleteEntry(_ entry: SugarEntry) {
        modelContext.delete(entry)
    }
}
