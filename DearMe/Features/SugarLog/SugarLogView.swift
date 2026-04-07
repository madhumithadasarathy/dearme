import SwiftUI

struct SugarLogView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Sugar Log")
                        
                        PlannerCard {
                            Text("Blood glucose tracking interface placeholder.")
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
