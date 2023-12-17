//
//  Defaults.swift
//  Butler
//
//  Created by Aditya Saravana on 7/7/23.
//

import Foundation
import Defaults

fileprivate let appVersionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

extension Defaults.Keys {
    static let userAPIKey = Key<String>("userAPIKey", default: "")
    static let windowSize = Key<AppWindowSize>("windowSize", default: .small)
    static let showLimitedAccessWarning = Key<Bool>("showLimitedAccessWarning", default: true)
    static let fontSize = Key<Double>("fontSize", default: 12.0)
    static let messagesSent = Key<Int>("messagesSent", default: 0)
    static let chatGPTTemperature = Key<Double>("chatGPTTemperature", default: 1)
    static let chatGPTModel = Key<ChatGPTModels>("chatGPTModel", default: .gpt3)
    static let useIconsInTopBar = Key<Bool>("useIconsInTopBar", default: false)
    static let highlightSyntax = Key<Bool>("highlightSyntax", default: false)
    static let showNewFeatures = Key<Bool>("showNewFeatures\(appVersionNumber)", default: true)
    static let textFieldLineLimit = Key<Int>("textFieldLineLimit", default: 7)
    static let onboard = Key<Bool>("onboard", default: true)
    //            ^            ^         ^                ^
    //           Key          Type   UserDefaults name   Default value
}

