import SwiftUI

struct SoftButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .bodyFont(size: 16)
                .fontWeight(.medium)
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color.Theme.blushPink)
                .foregroundColor(Color.Theme.textPrimary)
                .cornerRadius(20)
                .shadow(color: Color.Theme.blushPink.opacity(0.4), radius: 6, x: 0, y: 3)
        }
        .padding(.horizontal)
    }
}
