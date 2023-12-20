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
            return "GPT 4"
        case .gpt3:
            return "GPT 3.5"
        }
    }
    
    var modelID: ModelID {
        switch self {
        case .gpt4:
            return Model.GPT4.gpt4_1106_preview
        case .gpt3:
            return Model.GPT3.gpt3_5Turbo_1106
        }
    }
}
