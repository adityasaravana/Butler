//
//  OpenAIConnector.swift
//  Butler
//
//  Created by Aditya Saravana on 6/22/23.
//b

import Foundation
import Combine
import Defaults
import Network
import OpenAISwift


class OpenAIConnector: ObservableObject {
    /// This URL might change in the future, so if you get an error, make sure to check the OpenAI API Reference.
    
    let dataManager = DataManager()
    var connectedToInternet = true
    var openAI: OpenAISwift {
        return OpenAISwift(authToken: dataManager.pull(key: .Butler_UserOpenAIKey) ?? "invalid")
    }
    
    init(
        messageLog: [ChatMessage] = [ChatMessage(role: .system, content: "You are a helpful assistant.")]
    ) {
        self.messageLog = messageLog
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connectedToInternet = true
            } else {
                self.connectedToInternet = false
            }
            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "ConnectionTester")
        monitor.start(queue: queue)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            monitor.cancel()
        })
    }
    
    /// This is what stores your messages.
    @Published var messageLog: [ChatMessage] = [
        ChatMessage(role: .system, content: "You are a helpful assistant.")
    ]
    
    func clearMessageLog() {
        messageLog = [
            ChatMessage(role: .system, content: "You are a helpful assistant.")
        ]
        
        
    }
    
    func sendToAssistant() {
        
    }
    
    
}


/// Don't worry about this too much. This just gets rid of errors when using messageLog in a SwiftUI List or ForEach.
extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

extension OpenAIConnector {
    func logMessage(_ message: String, messageUserType: ChatRole) {
        DispatchQueue.main.async {
            self.messageLog.append(ChatMessage(role: messageUserType, content: message))
        }
    }
}
