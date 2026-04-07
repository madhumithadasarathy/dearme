import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    let healthStore = HKHealthStore()
    
    @Published var stepCount: Int = 0
    @Published var caloriesBurned: Int = 0
    @Published var isAuthorized: Bool = false
    
    private init() {}
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchTodaySteps()
                }
            }
        }
    }
    
    func fetchTodaySteps() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let sum = result?.sumQuantity() else { return }
            let count = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self.stepCount = count
                self.caloriesBurned = Int(Double(count) * 0.04)
            }
        }
        healthStore.execute(query)
    }
}
