//
//  OpenAIConnector.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Foundation
import Combine
import Network
import Defaults
import SwiftUI
import OpenAIKit

class OpenAIConnector: ObservableObject {
    static let shared = OpenAIConnector()
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    #if DEBUG
    var openAIKey = "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"
    #else
    var openAIKey = Defaults[.userAPIKey]
    #endif
    
    var client: OpenAIKit.Client
    
    init() {
        
        
        let urlSession = URLSession(configuration: .default)
        let configuration = Configuration(apiKey: openAIKey)
        client = OpenAIKit.Client(session: urlSession, configuration: configuration)
        
    }
    
    static let empty = [["role": "system", "content": "You're a friendly, helpful assistant"]]
    /// This is what stores your messages.
    @Published var messages: [Chat.Message] = []
    
    var messagesEmpty: Bool {
        return false
    }
    
    func deleteAll() {
        messages.removeAll()
    }
    
    func sendToAssistant() async {
        if self.openAIKey != "" {
            Defaults[.messagesSent] += 1
            
            do {
                
                let completion = try await client.chats.create(model: Model.GPT3.gpt3_5Turbo, messages: messages)
                
                messages.append(completion.choices.first?.message ?? Chat.Message.assistant(content: "nil"))
            } catch {
                Defaults[.messagesSent] -= 1
                
                self.logMessage("SendToAssistant caught.", user: .assistant)
            }
        } else {
            if !Defaults[.onboard] {
                self.logMessage("You haven't entered an OpenAI API key. To add one, open Settings, and add it in the ChatGPT settings menu.", user: .assistant)
            } else {
                self.logMessage("Looks like you haven't entered anything in the text field above. Paste your API key in and try again.", user: .assistant)
            }
        }
        
    }
}


/// Don't worry about this too much. This just gets rid of errors when using messages in a SwiftUI List or ForEach.
extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

extension OpenAIConnector {
    /// This function makes it simpler to append items to messages.
    func logMessage(_ message: String, user: MessageUserType) {
        var userString = ""
        switch user {
        case .user:
            messages.append(Chat.Message.user(content: message))
        case .assistant:
            messages.append(Chat.Message.assistant(content: message))
        }
    }
    
    enum MessageUserType {
        case user
        case assistant
    }
}
