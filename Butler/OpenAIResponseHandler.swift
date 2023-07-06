//
//  OpenAIResponseHandler.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Foundation

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Response -- \(error)")
        }
        
        return nil
    }
    
    func decodeError(jsonString: String) -> OpenAIErrorResponse? {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        do {
            let product = try decoder.decode(OpenAIErrorResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Error Response -- \(error)")
        }
        
        return nil
    }
    
}

struct OpenAIResponse: Codable {
    var id: String?
    var object: String?
    var created: Int?
    var choices: [Choice]
    var usage: Usage?
}

struct Choice: Codable {
    var index: Int?
    var message: [String: String]
    var finish_reason: String?
}

struct Usage: Codable {
    var prompt_tokens: Int?
    var completion_tokens: Int?
    var total_tokens: Int?
}

struct OpenAIErrorResponse: Codable {
    var error: OpenAIError
}

struct OpenAIError: Codable {
    var message: String?
    var type: String?
    var param: String?
    var code: String?
}
