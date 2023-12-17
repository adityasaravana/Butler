//
//  ChatGPTModels.swift
//  Butler
//
//  Created by Aditya Saravana on 6/28/23.
//

import Foundation
import Defaults

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
}
