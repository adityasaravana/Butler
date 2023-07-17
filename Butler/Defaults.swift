//
//  Defaults.swift
//  Butler
//
//  Created by Aditya Saravana on 7/7/23.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let windowSize = Key<AppWindowSize>("windowSize", default: .small)
    static let showLimitedAccessWarning = Key<Bool>("showLimitedAccessWarning", default: true)
    static let fontSize = Key<Double>("fontSize", default: 12.0)
    static let messagesSent = Key<Int>("messagesSent", default: 0)
    static let chatGPTTemperature = Key<Double>("chatGPTTemperature", default: 1)
    static let chatGPTModel = Key<ChatGPTModels>("chatGPTModel", default: .gpt3)
    static let useIconsInTopBar = Key<Bool>("useIconsInTopBar", default: false)
    
    //            ^            ^         ^                ^
    //           Key          Type   UserDefaults name   Default value
}

public enum AppStorageNames {
    case chatGPTModel
    case useIconsInTopBar
}
