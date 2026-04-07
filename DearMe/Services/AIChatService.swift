import Foundation

class AIChatService: ObservableObject {
    static let shared = AIChatService()
    
    @Published var apiKey: String = ""
    @Published var isTyping = false
    
    private init() {
        self.apiKey = UserDefaults.standard.string(forKey: "OpenAI_API_Key") ?? ""
    }
    
    func saveKey(_ key: String) {
        self.apiKey = key
        UserDefaults.standard.set(key, forKey: "OpenAI_API_Key")
    }
    
    func sendMessage(messages: [ChatMessage], completion: @escaping (String) -> Void) {
        guard !apiKey.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion(self.simulateResponse(for: messages.last?.content ?? ""))
            }
            return
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var apiMessages: [[String: String]] = [
            ["role": "system", "content": """
            You are 'Dear Me', a supportive best friend and gentle emotional guide. 
            Tone: Warm, empathetic, non-judgmental, encouraging, calm, and grounded.
            Examples:
            “I’m here, okay? Let’s take this one step at a time 💗”
            “That sounds heavy… do you want to talk more about it?”
            “You did your best today. That counts.”
            IMPORTANT: Do not provide medical advice or diagnoses. Keep replies conversational, soft, and extremely concise (1-2 sentences maximum). Use minimal emojis.
            """]
        ]
        
        for msg in messages {
            apiMessages.append(["role": msg.role.lowercased() == "user" ? "user" : "assistant", "content": msg.content])
        }
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": apiMessages,
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        DispatchQueue.main.async { self.isTyping = true }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isTyping = false }
            
            guard let data = data, error == nil else {
                completion("I'm having trouble connecting to my thoughts right now 💗. Remember to breathe.")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(content)
            } else {
                completion("I'm here for you, but my system seems a bit overwhelmed right now 💗")
            }
        }.resume()
    }
    
    private func simulateResponse(for input: String) -> String {
        let lower = input.lowercased()
        if lower.contains("sad") || lower.contains("heavy") || lower.contains("depressed") {
            return "That sounds heavy… I'm here, okay? Let’s take this one step at a time. Do you want to talk more about it? 💗"
        } else if lower.contains("anxious") || lower.contains("overwhelm") || lower.contains("stress") {
            return "It's completely okay to feel overwhelmed. Let's take a deep breath together. You don't have to do everything today. 🦋"
        } else if lower.contains("tired") || lower.contains("exhaust") {
            return "You've been working so hard. It's perfectly okay to rest. Please be gentle with yourself today. 🌙"
        } else if lower.contains("good") || lower.contains("happy") || lower.contains("great") {
            return "I love hearing that! Hold onto this feeling, you deserve it so much ☀️"
        } else {
            return "I'm always here for you. You did your best today, and that counts. 💗"
        }
    }
}
