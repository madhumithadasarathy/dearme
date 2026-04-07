import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Good Morning")
                        
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
    }
}
