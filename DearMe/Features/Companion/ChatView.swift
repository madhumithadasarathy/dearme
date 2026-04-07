import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \ChatMessage.timestamp) private var messages: [ChatMessage]
    
    @StateObject private var aiService = AIChatService.shared
    @State private var inputText: String = ""
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Theme.cream.opacity(0.5).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 12) {
                                if messages.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 40))
                                            .foregroundColor(Color.Theme.dustyRose)
                                        Text("I'm here for you, love. What's on your mind?")
                                            .font(.headline)
                                            .foregroundColor(Color.Theme.textPrimary)
                                    }
                                    .padding(.top, 60)
                                }
                                
                                ForEach(messages) { message in
                                    ChatBubble(message: message)
                                }
                                
                                if aiService.isTyping {
                                    HStack {
                                        Text("Typing...")
                                            .font(.caption)
                                            .foregroundColor(Color.Theme.textSecondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastId = messages.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastId, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Talk to me...", text: $inputText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(24)
                            .shadow(color: Color.black.opacity(0.02), radius: 3)
                            .onSubmit { sendMessage() }
                        
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.Theme.textSecondary : .white)
                                .padding(12)
                                .background(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.1) : Color.Theme.dustyRose)
                                .clipShape(Circle())
                        }
                        .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding()
                    .background(Color.Theme.cream)
                }
            }
            .navigationTitle("Companion")
            .navigationBarItems(
                leading: Button("Close") { dismiss() }.foregroundColor(Color.Theme.textPrimary),
                trailing: Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(Color.Theme.textSecondary)
                }
            )
            .sheet(isPresented: $showSettings) {
                NavigationView {
                    Form {
                        Section(header: Text("OpenAI API Key (Optional)"), footer: Text("Enter a functional OpenAI Key to unlock true AI intelligence. Otherwise, Dear Me relies on local preset simulation constraints.")) {
                            SecureField("Enter Key (sk-...)", text: $aiService.apiKey)
                        }
                        Section {
                            Button("Clear Chat History", role: .destructive) {
                                clearHistory()
                            }
                        }
                    }
                    .navigationTitle("Chat Settings")
                    .navigationBarItems(trailing: Button("Done") { 
                        aiService.saveKey(aiService.apiKey)
                        showSettings = false 
                    }.foregroundColor(Color.Theme.dustyRose).fontWeight(.bold))
                }
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let messageText = inputText
        inputText = ""
        
        let userMsg = ChatMessage(role: "user", content: messageText)
        modelContext.insert(userMsg)
        
        aiService.isTyping = true
        aiService.sendMessage(messages: messages) { responseContent in
            let botMsg = ChatMessage(role: "assistant", content: responseContent)
            modelContext.insert(botMsg)
            RewardEngine.shared.addPoints(context: modelContext, amount: 5)
        }
    }
    
    func clearHistory() {
        for msg in messages {
            modelContext.delete(msg)
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var isUser: Bool { message.role.lowercased() == "user" }
    
    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 40) }
            
            Text(message.content)
                .bodyFont()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isUser ? Color.Theme.blushPink : Color.white)
                .foregroundColor(isUser ? Color.Theme.textPrimary : Color.Theme.textPrimary)
                .cornerRadius(20, corners: isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .shadow(color: Color.black.opacity(0.02), radius: 4)
            
            if !isUser { Spacer(minLength: 40) }
        }
        .padding(.horizontal)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ChatView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
}
