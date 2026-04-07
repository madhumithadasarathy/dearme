import SwiftUI
import SwiftData

struct WellnessView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var healthManager = HealthKitManager.shared
    
    @Query private var periodLogs: [PeriodTracking]
    var tracking: PeriodTracking? { periodLogs.first }
    
    @State private var showingPeriodLogger = false
    @State private var selectedDate = Date()
    @AppStorage("currentDayMode") private var currentDayMode = "Full Day"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Wellness")
                        
                        PlannerCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Physical Activity")
                                        .headingFont(size: 20)
                                        .foregroundColor(Color.Theme.textPrimary)
                                    Spacer()
                                    if !healthManager.isAuthorized {
                                        Button("Connect Health") {
                                            healthManager.requestAuthorization()
                                        }
                                        .font(.caption).fontWeight(.bold)
                                        .foregroundColor(Color.Theme.dustyRose)
                                    } else {
                                        Button(action: { healthManager.fetchTodaySteps() }) {
                                            Image(systemName: "arrow.clockwise")
                                                .foregroundColor(Color.Theme.textSecondary)
                                        }
                                    }
                                }
                                
                                HStack(spacing: 20) {
                                    VStack(alignment: .leading) {
                                        Text("Steps Today")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Text("\(healthManager.stepCount)")
                                            .font(.system(size: 32, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.Theme.textPrimary)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Est. Calories")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Text("\(healthManager.caloriesBurned) kcal")
                                            .font(.system(size: 32, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.Theme.textPrimary)
                                    }
                                }
                                
                                let progress = min(CGFloat(healthManager.stepCount) / 8000.0, 1.0)
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geometry.size.width, height: 8)
                                            .opacity(0.15)
                                            .foregroundColor(Color.gray)
                                        
                                        Rectangle()
                                            .frame(width: progress * geometry.size.width, height: 8)
                                            .foregroundColor(Color.Theme.normalRange)
                                    }
                                    .cornerRadius(4)
                                }
                                .frame(height: 8)
                            }
                        }
                        
                        PlannerCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Reproductive Health")
                                    .headingFont(size: 20)
                                    .foregroundColor(Color.Theme.textPrimary)
                                
                                if let period = tracking {
                                    HStack(spacing: 40) {
                                        VStack(alignment: .leading) {
                                            Text("Last Cycle")
                                                .font(.caption)
                                                .foregroundColor(Color.Theme.textSecondary)
                                            Text(period.lastPeriodStartDate, style: .date)
                                                .font(.headline)
                                                .foregroundColor(Color.Theme.textPrimary)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Predicted Next")
                                                .font(.caption)
                                                .foregroundColor(Color.Theme.textSecondary)
                                            Text(period.predictedNextCycleDate, style: .date)
                                                .font(.headline)
                                                .foregroundColor(Color.Theme.dustyRose)
                                        }
                                    }
                                    
                                    let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: period.predictedNextCycleDate).day ?? 10
                                    
                                    if daysUntil <= 3 && daysUntil >= -3 {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Cycle is approaching or active. Consider setting your daily mode to 'Low Energy Day' to rest.")
                                                .font(.caption)
                                                .foregroundColor(Color.Theme.dustyRose)
                                                
                                            Button("Set Low Energy Mode") {
                                                currentDayMode = "Low Energy Day"
                                            }
                                            .font(.caption).fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.Theme.blushPink.opacity(0.5))
                                            .foregroundColor(Color.Theme.dustyRose)
                                            .cornerRadius(8)
                                        }
                                        .padding(.top, 4)
                                    }
                                    
                                } else {
                                    Text("No cycle data recorded yet.")
                                        .bodyFont()
                                        .foregroundColor(Color.Theme.textSecondary)
                                }
                                
                                SoftButton(title: tracking == nil ? "Log Period" : "Update Cycle Start Date") {
                                    showingPeriodLogger = true
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingPeriodLogger) {
                NavigationView {
                    Form {
                        Section(header: Text("Cycle Tracker")) {
                            DatePicker("Last Start Date", selection: $selectedDate, displayedComponents: .date)
                        }
                    }
                    .navigationTitle("Log Period")
                    .navigationBarItems(
                        leading: Button("Cancel") { showingPeriodLogger = false },
                        trailing: Button("Save") {
                            savePeriod()
                            showingPeriodLogger = false
                        }.fontWeight(.bold).foregroundColor(Color.Theme.dustyRose)
                    )
                }
            }
        }
        .onAppear {
            if healthManager.isAuthorized {
                healthManager.fetchTodaySteps()
            }
        }
    }
    
    func savePeriod() {
        if let existing = tracking {
            existing.lastPeriodStartDate = selectedDate
        } else {
            let newLog = PeriodTracking(lastPeriodStartDate: selectedDate)
            modelContext.insert(newLog)
            RewardEngine.shared.addPoints(context: modelContext, amount: 20)
        }
        
        NotificationManager.shared.scheduleAllNotifications(context: modelContext)
    }
}

#Preview {
    WellnessView()
        .modelContainer(for: PeriodTracking.self, inMemory: true)
}
