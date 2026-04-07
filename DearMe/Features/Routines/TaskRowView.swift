import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext
    let task: RoutineTask
    let dateString: String
    
    @State private var isTimerActive = false
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    
    var completion: RoutineCompletion? {
        task.completions?.first(where: { $0.dateString == dateString })
    }
    
    var isCompleted: Bool {
        completion?.isCompleted ?? false
    }
    
    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? Color.Theme.normalRange : Color.Theme.textSecondary)
                    .font(.system(size: 24))
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .bodyFont()
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? Color.Theme.textSecondary : Color.Theme.textPrimary)
                
                if let duration = task.timerDurationSeconds, !isCompleted {
                    if isTimerActive {
                        Text("Time remaining: \(timeRemaining)s")
                            .font(.caption)
                            .foregroundColor(Color.Theme.accent)
                    } else {
                        Button("Start " + ((duration >= 60) ? "\(duration/60) min" : "\(duration)s") + " Timer") {
                            startTimer(duration: duration)
                        }
                        .font(.caption)
                        .foregroundColor(Color.Theme.dustyRose)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .opacity(isCompleted ? 0.6 : 1.0)
    }
    
    func startTimer(duration: Int) {
        timeRemaining = duration
        isTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isTimerActive = false
                toggleCompletion()
            }
        }
    }
    
    func toggleCompletion() {
        if let completion = completion {
            completion.isCompleted.toggle()
            completion.completionTimestamp = completion.isCompleted ? Date() : nil
        } else {
            let newCompletion = RoutineCompletion(date: Date(), isCompleted: true, completionTimestamp: Date())
            newCompletion.task = task
            modelContext.insert(newCompletion)
            if task.completions == nil {
                task.completions = []
            }
            task.completions?.append(newCompletion)
        }
    }
}
