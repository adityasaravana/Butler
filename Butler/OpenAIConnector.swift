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

class OpenAIConnector: ObservableObject {
    static let shared = OpenAIConnector()
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    var connectedToInternet = true
    var openAIKey: String {
        return Defaults[.userAPIKey] 
    }
    
    init(messages: [[String: String]] = OpenAIConnector.empty) {
        self.messages = messages
        
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
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(4), execute: {
            monitor.cancel()
        })
    }
    
    static let empty = [["role": "system", "content": "You're a friendly, helpful assistant"]]
    /// This is what stores your messages.
    @Published var messages: [[String: String]] = empty
    
    var messagesEmpty: Bool {
        return messages == OpenAIConnector.empty
    }
    
    func deleteAll() {
        messages = OpenAIConnector.empty
    }
    
    func sendToAssistant() {
        if connectedToInternet {
            if self.openAIKey != "" {
                Defaults[.messagesSent] += 1
                
                
                var request = URLRequest(url: self.openAIURL!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
                
                let httpBody: [String: Any] = [
                    /// In the future, you can use a different chat model here.
                    "model" : Defaults[.chatGPTModel].name,
                    "messages" : self.messages,
                    "temperature" : Defaults[.chatGPTTemperature]
                ]
                
                /// DON'T TOUCH THIS
                var httpBodyJson: Data? = nil
                
                do {
                    httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
                } catch {
                    print("Unable to convert to JSON \(error)")
                    self.logMessage("Error: \(error.localizedDescription), email aditya.saravana@icloud.com with a screenshot.", user: .assistant)
                    Defaults[.messagesSent] -= 1
                }
                
                request.httpBody = httpBodyJson
                
                if let requestData = self.executeRequest(request: request, withSessionConfig: nil) {
                    let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    print(jsonStr)
                    let responseHandler = OpenAIResponseHandler()
                    
                    let response = responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"] ?? responseHandler.decodeError(jsonString: jsonStr)?.error.message ?? "Error decoding error: take a screenshot and email aditya.saravana@icloud.com"
                    
                    self.logMessage(response, user: .assistant)
                    
                    Defaults[.messagesSent] -= 1
                }
            } else {
                if !Defaults[.onboard] {
                    self.logMessage("You haven't entered an OpenAI API key. To add one, open Settings, and add it in the ChatGPT settings menu.", user: .assistant)
                } else {
                    self.logMessage("Looks like you haven't entered anything in the text field above. Paste your API key in and try again.", user: .assistant)
                }
            }
        } else {
            self.logMessage("You're not connected to the Internet. Connect and try again.", user: .assistant)
        }
    }
}


/// Don't worry about this too much. This just gets rid of errors when using messages in a SwiftUI List or ForEach.
extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

/// DO NOT TOUCH THIS. LEAVE IT ALONE.
extension OpenAIConnector {
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        })
        task.resume()
        
        // Handle async with semaphores. Max wait of 60 seconds
        let timeout = DispatchTime.now() + .seconds(60)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        if retVal == .timedOut {
            logMessage("Your request took too long to process. Try again with a different prompt.", user: .assistant)
            Defaults[.messagesSent] -= 1
        }
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
}

extension OpenAIConnector {
    /// This function makes it simpler to append items to messages.
    func logMessage(_ message: String, user: MessageUserType) {
            var userString = ""
            switch user {
            case .user:
                userString = "user"
            case .assistant:
                userString = "assistant"
            }
            
            
            self.messages.append(["role": userString, "content": message])
        
    }
    enum MessageUserType {
        case user
        case assistant
    }
}
