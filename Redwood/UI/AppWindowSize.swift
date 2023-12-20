//
//  AppWindowSize.swift
//  Butler
//
//  Created by Aditya Saravana on 7/7/23.
//

import Foundation
import SwiftUI
import Defaults

public enum AppWindowSize: Codable, Defaults.Serializable, CaseIterable, Identifiable {
    public var id: Self { self }
    case small
    case medium
    case large
    case tall
    
    var name: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .tall:
            return "Tall"
        }
    }
     
    var size: (CGFloat, CGFloat) {
        switch self {
        case .small:
            return (400, 500)
        case .medium:
            return (500, 600)
        case .large:
            return (700, 800)
        case .tall:
            return (500, 800)
        }
    }
}

