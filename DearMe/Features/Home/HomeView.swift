import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [RoutineTask]
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    var todayTasks: [RoutineTask] {
        tasks.filter { $0.activeModes.contains("Full Day") }
    }
    
    var completedCount: Int {
        todayTasks.filter { task in
            task.completions?.contains(where: { $0.dateString == todayDateString && $0.isCompleted }) == true
        }.count
    }
    
    var totalCount: Int {
        todayTasks.count
    }
    
    var completionPercentage: Double {
        if totalCount == 0 { return 0.0 }
        return Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Good Morning")
                        
                        // Progress Section
                        PlannerCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Daily Progress")
                                    .headingFont(size: 20)
                                    .foregroundColor(Color.Theme.textPrimary)
                                
                                HStack {
                                    Text("\(completedCount) of \(totalCount) completed")
                                        .bodyFont()
                                        .foregroundColor(Color.Theme.textSecondary)
                                    Spacer()
                                    Text("\(Int(completionPercentage * 100))%")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.Theme.dustyRose)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geometry.size.width, height: 12)
                                            .opacity(0.3)
                                            .foregroundColor(Color.gray)
                                        
                                        Rectangle()
                                            .frame(width: min(CGFloat(completionPercentage) * geometry.size.width, geometry.size.width), height: 12)
                                            .foregroundColor(Color.Theme.normalRange)
                                    }
                                    .cornerRadius(6)
                                }
                                .frame(height: 12)
                            }
                        }
                        
                        PlannerCard {
                            Text("Your Daily Dashboard will appear here.")
                                .bodyFont()
                                .foregroundColor(Color.Theme.textSecondary)
                        }
                        
                        SoftButton(title: "Begin Your Day") {
                            // Action placeholder
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            NotificationManager.shared.requestPermission { granted in
                if granted {
                    NotificationManager.shared.scheduleAllNotifications(context: modelContext)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [RoutineTask.self, RoutineCompletion.self], inMemory: true)
}
