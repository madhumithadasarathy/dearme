import SwiftUI

struct RoutinesView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Routines")
                        
                        PlannerCard {
                            Text("Self-care and productivity checklists placeholder.")
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
