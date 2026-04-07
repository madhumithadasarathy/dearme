import SwiftUI

struct SugarGridCell: View {
    let entry: SugarEntry?
    let slot: SugarTimeSlot
    let action: () -> Void
    
    var bgColor: Color {
        guard let e = entry else { return Color.white }
        return e.statusColor
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                
                if let e = entry {
                    Text("\(e.glucoseValue)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                } else {
                    Text("-")
                        .foregroundColor(Color.Theme.textSecondary.opacity(0.4))
                }
            }
            .frame(height: 38)
            .frame(maxWidth: .infinity)
        }
    }
}
