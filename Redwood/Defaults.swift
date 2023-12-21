//
//  Defaults.swift
//  Butler
//
//  Created by Aditya Saravana on 7/7/23.
//

import Foundation
import Defaults
import OpenAIKit

extension Defaults.Keys {
    static let userAPIKey = Key<String>("userAPIKey", default: "")
    static let windowSize = Key<AppWindowSize>("windowSize", default: .small)
    static let fontSize = Key<Double>("fontSize", default: 12.0)
    static let messagesSent = Key<Int>("messagesSent", default: 0)
    static let chatGPTModel = Key<ChatGPTModels>("chatGPTModel", default: .gpt3)
    static let topBarButtonStyle = Key<TopBarButtonsStyle>("topBarButtonStyle", default: .text)
    static let chats = Key<[String: [Chat.Message]]>("chats", default: [:])
    static let lastChatID = Key<String?>("lastChatID", default: nil)
}

