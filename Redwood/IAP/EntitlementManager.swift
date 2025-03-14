//
//  EntitlementManager.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/21/23.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
