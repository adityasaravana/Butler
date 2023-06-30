//
//  ChatGPTModels.swift
//  Butler
//
//  Created by Aditya Saravana on 6/28/23.
//

import Foundation

public enum ChatGPTModels {
    case gpt4
    case gpt3
    
    static var allCases: [Self] {
        return [.gpt3, .gpt4]
    }
    
    var name: String {
        switch self {
        case .gpt4:
            return "gpt-4"
        case .gpt3:
            return "gpt-3.5-turbo"
        }
    }
}
