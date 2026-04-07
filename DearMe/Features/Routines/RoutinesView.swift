import SwiftUI
import SwiftData

struct RoutinesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [RoutineTask]

    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Routines")
                        
                        if tasks.isEmpty {
                            PlannerCard {
                                Text("No routines yet. Add your first task!")
                                    .bodyFont()
                                    .foregroundColor(Color.Theme.textSecondary)
                            }
                        } else {
                            ForEach(tasks) { task in
                                PlannerCard {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(task.title)
                                                .bodyFont()
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.Theme.textPrimary)
                                            Text(task.category)
                                                .font(.caption)
                                                .foregroundColor(Color.Theme.textSecondary)
                                        }
                                        Spacer()
                                        Button(action: {
                                            deleteTask(task)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(Color.Theme.critical)
                                        }
                                    }
                                }
                            }
                        }
                        
                        SoftButton(title: "Add Sample Routine") {
                            addSampleTask()
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func addSampleTask() {
        let newTask = RoutineTask(title: "Morning Skincare", category: "Self-care", estimatedDurationMinutes: 15, pointsValue: 10)
        modelContext.insert(newTask)
    }
    
    private func deleteTask(_ task: RoutineTask) {
        modelContext.delete(task)
    }
}
