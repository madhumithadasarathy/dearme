import SwiftUI

struct SugarDayRow: View {
    let dateString: String
    let dayEntries: [SugarEntry]
    let onCellTap: (SugarTimeSlot) -> Void
    
    var displayDate: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        if let date = f.date(from: dateString) {
            let df = DateFormatter()
            df.dateFormat = "MMM d"
            return df.string(from: date)
        }
        return dateString
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(displayDate)
                .font(.caption2)
                .fontWeight(.bold)
                .frame(width: 45, alignment: .leading)
                .foregroundColor(Color.Theme.textPrimary)
            
            ForEach(SugarTimeSlot.allCases, id: \.self) { slot in
                let entry = dayEntries.first(where: { $0.timeSlot == slot })
                SugarGridCell(entry: entry, slot: slot) {
                    onCellTap(slot)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.Theme.cream)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}
