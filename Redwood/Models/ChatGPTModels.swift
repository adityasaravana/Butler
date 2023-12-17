//
//  ChatGPTModels.swift
//  Butler
//
//  Created by Aditya Saravana on 6/28/23.
//

import Foundation
import Defaults
import OpenAIKit

public enum ChatGPTModels: Codable, Defaults.Serializable, CaseIterable, Identifiable {
    public var id: Self { self }
    case gpt4
    case gpt3
    
    var name: String {
        switch self {
        case .gpt4:
            return "gpt-4"
        case .gpt3:
            return "gpt-3.5-turbo"
        }
    }
    
    var modelID: ModelID {
        switch self {
        case .gpt4:
            return Model.GPT4.gpt4
        case .gpt3:
            return Model.GPT3.gpt3_5Turbo
        }
    }
}
