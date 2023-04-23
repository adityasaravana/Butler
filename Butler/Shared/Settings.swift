//
//  Settings.swift
//  Butler
//
//  Created by Aditya Saravana on 4/22/23.
//

import Foundation

import Defaults

extension Defaults.Keys {
    /// User Settings
    static let fontSize = Key<Int>("fontSize", default: 12)
    static let windowSize = Key<String>("windowSize", default: "medium")
    
    /// Tracking
    static let messagesSuccessfullySent = Key<Int>("messagesSuccessfullySent", default: 0)
}
