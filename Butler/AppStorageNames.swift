//
//  UserDefaultsNames.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import Foundation

public enum AppStorageNames {
    case showLimitedAccessWarning
    case fontSize
    case messagesSent
    case chatGPTTemperature
    case chatGPTModel
    case useIconsInTopBar
    var name: String {
        switch self {
        case .showLimitedAccessWarning:
            return "showlimitedaccesswarning"
        case .fontSize:
            return "fontsize"
        case .messagesSent:
            return "messagessent"
        case .chatGPTTemperature:
            return "chatGPTtemperature"
        case .chatGPTModel:
            return "chatGPTmodel"
        case .useIconsInTopBar:
            return "useIconsInTopBarK"
        }
    }
}
