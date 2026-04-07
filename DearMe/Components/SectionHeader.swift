import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .headingFont(size: 24)
            .foregroundColor(Color.Theme.textPrimary)
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}
