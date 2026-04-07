import SwiftUI
import SwiftData

struct RoutinesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [RoutineTask]
    
    @State private var selectedMode = "Full Day"
    let modes = ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"]
    
    let categoryOrder = ["Morning Routine", "Skincare Routine", "Body Care", "Hair Routine", "Growth Block", "Creative Block", "Fitness Block", "Night Routine"]
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    var filteredTasks: [RoutineTask] {
        tasks.filter { $0.activeModes.contains(selectedMode) }
    }
    
    var groupedTasks: [(String, [RoutineTask])] {
        let active = filteredTasks
        var result: [(String, [RoutineTask])] = []
        for category in categoryOrder {
            let catTasks = active.filter { $0.category == category }
            if !catTasks.isEmpty {
                result.append((category, catTasks))
            }
        }
        return result
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Routines")
                        
                        Picker("Day Mode", selection: $selectedMode) {
                            ForEach(modes, id: \.self) { mode in
                                Text(mode).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        if tasks.isEmpty {
                            SoftButton(title: "Populate Default Routines") {
                                seedTasks()
                            }
                        } else {
                            ForEach(groupedTasks, id: \.0) { group in
                                PlannerCard {
                                    VStack(alignment: .leading) {
                                        Text(group.0)
                                            .headingFont(size: 20)
                                            .foregroundColor(Color.Theme.textPrimary)
                                            .padding(.bottom, 4)
                                        
                                        ForEach(group.1) { task in
                                            TaskRowView(task: task, dateString: todayDateString)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func seedTasks() {
        let defaultTasks = [
            RoutineTask(title: "Wake up (8 AM)", category: "Morning Routine", activeModes: ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"]),
            RoutineTask(title: "Brush", category: "Morning Routine", estimatedDurationMinutes: 2, activeModes: ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"]),
            RoutineTask(title: "Mouthwash", category: "Morning Routine", estimatedDurationMinutes: 1, timerDurationSeconds: 30, activeModes: ["Full Day", "Reset Day"]),
            
            RoutineTask(title: "Cleanser", category: "Skincare Routine", activeModes: ["Full Day", "Busy Day", "Reset Day"]),
            RoutineTask(title: "Serum", category: "Skincare Routine", activeModes: ["Full Day"]),
            RoutineTask(title: "Moisturizer", category: "Skincare Routine", activeModes: ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"]),
            RoutineTask(title: "Sunscreen", category: "Skincare Routine", activeModes: ["Full Day", "Busy Day", "Low Energy Day"]),
            
            RoutineTask(title: "Body wash", category: "Body Care", activeModes: ["Full Day", "Reset Day"]),
            RoutineTask(title: "Lotion", category: "Body Care", activeModes: ["Full Day", "Reset Day"]),
            
            RoutineTask(title: "Hair oiling", category: "Hair Routine", timerDurationSeconds: 3600, activeModes: ["Full Day", "Reset Day"]),
            RoutineTask(title: "Hair wash", category: "Hair Routine", activeModes: ["Full Day", "Reset Day"]),
            RoutineTask(title: "Hair mask", category: "Hair Routine", activeModes: ["Full Day", "Reset Day"]),
            
            RoutineTask(title: "Build something", category: "Growth Block", activeModes: ["Full Day", "Busy Day"]),
            
            RoutineTask(title: "Drawing", category: "Creative Block", timerDurationSeconds: 3600, activeModes: ["Full Day", "Reset Day"]),
            RoutineTask(title: "Reading", category: "Creative Block", timerDurationSeconds: 3600, activeModes: ["Full Day", "Reset Day"]),
            
            RoutineTask(title: "Gym / Walk", category: "Fitness Block", timerDurationSeconds: 3600, activeModes: ["Full Day"]),
            
            RoutineTask(title: "Wind down", category: "Night Routine", activeModes: ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"]),
            RoutineTask(title: "Journal", category: "Night Routine", activeModes: ["Full Day", "Reset Day"]),
            RoutineTask(title: "Sleep before 12 AM", category: "Night Routine", activeModes: ["Full Day", "Busy Day", "Low Energy Day", "Reset Day"])
        ]
        
        for task in defaultTasks {
            modelContext.insert(task)
        }
    }
}

#Preview {
    RoutinesView()
        .modelContainer(for: RoutineTask.self, inMemory: true)
}
