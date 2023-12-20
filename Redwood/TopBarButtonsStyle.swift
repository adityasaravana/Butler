//
//  TopBarStyle.swift
//  Redwood
//
//  Created by NMS15065-8-adisara on 12/19/23.
//

import Foundation
import Defaults

enum TopBarButtonsStyle: _Defaults.Serializable, Codable, CaseIterable, Identifiable {
    public var id: Self { self }
    
    case text
    case icons
    case emoji
    
    var name: String {
        switch self {
        case .text:
            return "Text"
        case .icons:
            return "Icons"
        case .emoji:
            return "Emoji"
        }
    }
}
