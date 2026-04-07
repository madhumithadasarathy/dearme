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
    
    var body: some View {
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

    }
}

#Preview {
    MainTabView()
}
