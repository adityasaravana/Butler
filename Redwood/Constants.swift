//
//  Constants.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/18/23.
//

import Foundation
import Defaults

struct Constants {
    static let chatGPTPrompt = Defaults[.userChatGPTPrompt] + ""
}
