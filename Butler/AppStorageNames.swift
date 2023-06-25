//
//  UserDefaultsNames.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import Foundation

public enum AppStorageNames {
    case fontSize
    case messagesSent
    case chatGPTTemperature
    
    var name: String {
        switch self {
        case .fontSize:
            return "butler.fontSize"
        case .messagesSent:
            return "butler.messagesSent"
        case .chatGPTTemperature:
            return "butler.chatGPT.temperature"
        }
    }
}
