import SwiftUI

struct SugarInputSheet: View {
    var date: Date
    var slot: SugarTimeSlot
    @Binding var glucoseInput: String
    @Binding var notesInput: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recording for \(slot.fullName)")) {
                    TextField("Glucose Value (mg/dL)", text: $glucoseInput)
                        .keyboardType(.numberPad)
                    
                    TextField("Optional Notes (e.g., Insulin)", text: $notesInput)
                }
            }
            .navigationTitle("Log Sugar")
            .navigationBarItems(
                leading: Button("Cancel", action: onCancel),
                trailing: Button("Save", action: onSave)
                    .fontWeight(.bold)
                    .foregroundColor(Color.Theme.dustyRose)
            )
        }
    }
}
