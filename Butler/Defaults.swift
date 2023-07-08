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
    //            ^            ^         ^                ^
    //           Key          Type   UserDefaults name   Default value
}
