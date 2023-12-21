//
//  OpenAIConnector.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Foundation
import Defaults
import OpenAIKit

class OpenAIConnector: ObservableObject {
    static let shared = OpenAIConnector()
    var openAIKey = Defaults[.userAPIKey]
    var client: OpenAIKit.Client
    
    var chatID: String
    
    init() {
        let urlSession = URLSession(configuration: .default)
        let configuration = Configuration(apiKey: openAIKey)
        client = OpenAIKit.Client(session: urlSession, configuration: configuration)
        chatID = UUID().uuidString
//        Defaults[.lastChatID] = chatID
//        Defaults[.chats][chatID] = messages
    }
    
    @Published var messages: [Chat.Message] = [
        .system(content: Constants.chatGPTPrompt)
    ]
    
    func sendToAssistant() async {
        if !self.openAIKey.isEmpty {
            Defaults[.messagesSent] += 1
            
            do {
                let completion = try await client.chats.create(model: Defaults[.chatGPTModel].modelID, messages: messages)
                
                messages.append(completion.choices.first?.message ?? Chat.Message.assistant(content: "nil"))
            } catch {
                Defaults[.messagesSent] -= 1
                
                self.logMessage("SendToAssistant caught.", user: .assistant)
            }
        } else {
            self.logMessage("You haven't entered an OpenAI API key. To add one, open Settings, and add it in the ChatGPT settings menu.", user: .assistant)
        }
    }
}

extension OpenAIConnector {
    /// This function makes it simpler to append items to messages.
    func logMessage(_ message: String, user: MessageUserType) {
        switch user {
        case .user:
            messages.append(Chat.Message.user(content: message))
        case .assistant:
            messages.append(Chat.Message.assistant(content: message))
        }
        Defaults[.lastChatID] = chatID
        Defaults[.chats][chatID] = messages
    }
    
    enum MessageUserType {
        case user
        case assistant
    }
}

