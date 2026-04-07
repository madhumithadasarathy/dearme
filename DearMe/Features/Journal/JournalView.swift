import SwiftUI

struct JournalView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Journal")
                        
                        PlannerCard {
                            Text("Personal reflection and mood tracking placeholder.")
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
