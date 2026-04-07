import SwiftUI
import SwiftData

struct RewardsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var progressList: [RewardsProgress]
    
    var progress: RewardsProgress? {
        progressList.first
    }
    
    @State private var showRedeemAlert = false
    @State private var selectedReward: (String, Int) = ("", 0)
    
    let rewardShop = [
        ("Guilt-Free Custom Action", 50),
        ("Buy A Special Coffee", 100),
        ("Skip a non-essential task today", 150),
        ("Buy Something Online", 500)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Rewards")
                        
                        PlannerCard {
                            VStack(spacing: 12) {
                                Text("Total Points")
                                    .bodyFont()
                                    .foregroundColor(Color.Theme.textSecondary)
                                Text("\(progress?.totalPoints ?? 0)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.Theme.dustyRose)
                                
                                HStack(spacing: 40) {
                                    VStack {
                                        Text("Streak")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Text("\(progress?.currentStreak ?? 0) 🔥")
                                            .font(.title3).fontWeight(.bold)
                                    }
                                    VStack {
                                        Text("Best")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                        Text("\(progress?.longestStreak ?? 0) 🏆")
                                            .font(.title3).fontWeight(.bold)
                                    }
                                }
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                        }
                        
                        if let badges = progress?.achievementBadges, !badges.isEmpty {
                            SectionHeader(title: "Badges 🏅")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(badges, id: \.self) { badge in
                                        VStack {
                                            Circle()
                                                .fill(Color.Theme.blushPink)
                                                .frame(width: 60, height: 60)
                                                .overlay(Text("✨").font(.title))
                                            Text(badge)
                                                .font(.caption).fontWeight(.medium)
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        SectionHeader(title: "Reward Shop 🛍️")
                        VStack(spacing: 12) {
                            ForEach(rewardShop, id: \.0) { item in
                                PlannerCard {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.0)
                                                .bodyFont()
                                                .fontWeight(.medium)
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedReward = item
                                            showRedeemAlert = true
                                        }) {
                                            Text("\(item.1) pts")
                                                .font(.footnote).fontWeight(.bold)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(Color.Theme.dustyRose)
                                                .foregroundColor(.white)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .alert("Redeem Reward?", isPresented: $showRedeemAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Redeem") {
                    _ = RewardEngine.shared.redeemReward(context: modelContext, title: selectedReward.0, cost: selectedReward.1)
                }
            } message: {
                Text("Do you want to spend \(selectedReward.1) points on '\(selectedReward.0)'?")
            }
        }
        .onAppear {
            _ = RewardEngine.shared.fetchProgress(context: modelContext)
        }
    }
}

#Preview {
    RewardsView()
        .modelContainer(for: RewardsProgress.self, inMemory: true)
}
