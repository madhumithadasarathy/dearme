import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            Color.Theme.cream.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(Color.Theme.dustyRose)
                    
                Text("Welcome to Dear Me")
                    .font(.custom("Georgia", size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(Color.Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    
                Text("Your gentle space to track routines, monitor your health, reflect on your moods, and take life one tiny step at a time.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color.Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
                
                VStack(alignment: .leading, spacing: 20) {
                    OnboardingFeature(icon: "checklist", title: "Routines", description: "Flexible tracking for whatever energy level you have today.")
                    OnboardingFeature(icon: "drop.fill", title: "Sugar Log", description: "Color-coded daily logs to track your physical constraints easily.")
                    OnboardingFeature(icon: "heart.fill", title: "Wellness", description: "Seamless physical step tracking alongside your natural cycle.")
                    OnboardingFeature(icon: "message.fill", title: "Companion", description: "A supportive friend here for you 24/7. Just tap the sparkles.")
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text("Begin My Journey")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.Theme.dustyRose)
                        .cornerRadius(30)
                        .shadow(color: Color.Theme.dustyRose.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}

struct OnboardingFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.Theme.dustyRose)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.Theme.textPrimary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color.Theme.textSecondary)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
