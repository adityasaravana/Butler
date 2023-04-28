//
//  OpenAIConnector.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Foundation
import Combine
import Defaults
import Network

class OpenAIConnector: ObservableObject {
    /// This URL might change in the future, so if you get an error, make sure to check the OpenAI API Reference.
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    let dataManager = DataManager()
    var connectedToInternet = true
    var openAIKey: String {
        return dataManager.pull(key: .Butler_UserOpenAIKey) ?? "invalid"
    }
    
    init(messageLog: [[String: String]] = [["role": "system", "content": "You're a friendly, helpful assistant"]]) {
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
    }
    
    /// This is what stores your messages.
    @Published var messageLog: [[String: String]] = [
        /// Modify this to change the personality of the assistant.
        ["role": "system", "content": "You're a friendly, helpful assistant"]
    ]
    
    func clearMessageLog() {
        messageLog = [
            ["role": "system", "content": "You're a friendly, helpful assistant"]
        ]
        
        
    }

    func sendToAssistant() {
            
            if connectedToInternet {
                if self.openAIKey != "" {
                    Defaults[.messagesSuccessfullySent] += 1
                    
                    var request = URLRequest(url: self.openAIURL!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
                    
                    let httpBody: [String: Any] = [
                        /// In the future, you can use a different chat model here.
                        "model" : "gpt-3.5-turbo",
                        "messages" : self.messageLog
                    ]
                    
                    /// DON'T TOUCH THIS
                    var httpBodyJson: Data? = nil
                    
                    do {
                        httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
                    } catch {
                        print("Unable to convert to JSON \(error)")
                        self.logMessage("error: \(error)", messageUserType: .assistant)
                        Defaults[.messagesSuccessfullySent] -= 1
                    }
                    
                    request.httpBody = httpBodyJson
                    
                    if let requestData = self.executeRequest(request: request, withSessionConfig: nil) {
                        let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                        print(jsonStr)
                        let responseHandler = OpenAIResponseHandler()
                        
                        let response = responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"] ?? responseHandler.decodeError(jsonString: jsonStr)?.error.message ?? "Error decoding error: take a screenshot and email aditya.saravana@icloud.com" 
                        
                        self.logMessage(response, messageUserType: .assistant)
                        
                        Defaults[.messagesSuccessfullySent] -= 1
                    }
                    
                    
                } else {
                    self.logMessage("You haven't entered an OpenAI API key. To do so, please click on the 'Show Settings' button and paste your key into the designated field.", messageUserType: .assistant)
                }
            } else {
                self.logMessage("You're not connected to the Internet. Connect and try again.", messageUserType: .assistant)
            }
        }
        
    
}


/// Don't worry about this too much. This just gets rid of errors when using messageLog in a SwiftUI List or ForEach.
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
        
        // Handle async with semaphores. Max wait of 10 seconds
        let timeout = DispatchTime.now() + .seconds(60)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        if retVal == .timedOut {
            logMessage("Your request took too long to process. Try again with a different prompt.", messageUserType: .assistant)
            Defaults[.messagesSuccessfullySent] -= 1
        }
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
}

extension OpenAIConnector {
    /// This function makes it simpler to append items to messageLog.
    func logMessage(_ message: String, messageUserType: MessageUserType) {
        var messageUserTypeString = ""
        switch messageUserType {
        case .user:
            messageUserTypeString = "user"
        case .assistant:
            messageUserTypeString = "assistant"
        }
        
        messageLog.append(["role": messageUserTypeString, "content": message])
    }
    
    enum MessageUserType {
        case user
        case assistant
    }
}
