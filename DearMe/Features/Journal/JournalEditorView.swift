import SwiftUI
import SwiftData

struct JournalEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var mood: String = "Neutral"
    @State private var content: String = ""
    @State private var isLowDay: Bool = false
    
    let existingEntry: JournalEntry?
    
    let moods = ["Happy", "Calm", "Neutral", "Anxious", "Sad", "Overwhelmed"]
    
    let prompts = [
        "What went well today?",
        "What felt difficult?",
        "What am I grateful for?",
        "One kind thing I can tell myself?",
        "What do I need right now?"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("How do you feel today?")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(moods, id: \.self) { m in
                                Button(action: { mood = m }) {
                                    Text(m)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(mood == m ? Color.Theme.dustyRose : Color.gray.opacity(0.1))
                                        .foregroundColor(mood == m ? .white : Color.Theme.textPrimary)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Reflection")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                    
                    Menu("Use a prompt...") {
                        ForEach(prompts, id: \.self) { prompt in
                            Button(prompt) {
                                content += (content.isEmpty ? "" : "\n\n") + prompt + "\n"
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color.Theme.dustyRose)
                }
                
                Section {
                    Toggle("Today feels heavy (Enable Support Mode)", isOn: $isLowDay)
                        .tint(Color.Theme.dustyRose)
                } footer: {
                    Text("If enabled, your daily routines will simplify to reduce expectations and support recovery.")
                }
            }
            .navigationTitle(existingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { save() }.foregroundColor(Color.Theme.dustyRose).fontWeight(.bold)
            )
            .onAppear {
                if let e = existingEntry {
                    mood = e.mood
                    content = e.content
                    isLowDay = e.isLowDay
                }
            }
        }
    }
    
    func save() {
        if let e = existingEntry {
            e.mood = mood
            e.content = content
            e.isLowDay = isLowDay
        } else {
            let e = JournalEntry(date: Date(), content: content, mood: mood, isLowDay: isLowDay)
            modelContext.insert(e)
            
            RewardEngine.shared.addPoints(context: modelContext, amount: 20)
        }
        
        if isLowDay {
            UserDefaults.standard.set("Low Energy Day", forKey: "currentDayMode")
        }
        dismiss()
    }
}
