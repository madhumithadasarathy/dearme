import SwiftUI

struct WellnessView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Wellness")
                        
                        PlannerCard {
                            Text("Period tracking, steps, and mental health support placeholder.")
                                .bodyFont()
                                .foregroundColor(Color.Theme.textSecondary)
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
