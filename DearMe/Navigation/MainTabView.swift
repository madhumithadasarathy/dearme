import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.Theme.cream)
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = UIColor(Color.Theme.dustyRose)
    }
    
    @State private var showingCompanion = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                RoutinesView()
                    .tabItem {
                        Image(systemName: "checklist")
                        Text("Routines")
                    }
                
                SugarLogView()
                    .tabItem {
                        Image(systemName: "drop.fill")
                        Text("Sugar Log")
                    }
                
                JournalView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Journal")
                    }
                
                WellnessView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Wellness")
                    }
                
                RewardsView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Rewards")
                    }
            }
            .accentColor(Color.Theme.dustyRose)
            
            Button(action: { showingCompanion = true }) {
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(18)
                    .background(Color.Theme.dustyRose)
                    .clipShape(Circle())
                    .shadow(color: Color.Theme.dustyRose.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 60)
        }
        .fullScreenCover(isPresented: $showingCompanion) {
            ChatView()
        }
    }
}

#Preview {
    MainTabView()
}

