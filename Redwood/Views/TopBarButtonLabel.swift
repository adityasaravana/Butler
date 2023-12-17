//
//  TopBarButtonLabel.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/17/23.
//

import SwiftUI

struct TopBarButtonLabel: View {
    var useIconsInTopBar: Bool
    var text: String
    var icon: String
    
    init(_ useIconsInTopBar: Bool, text: String, icon: String) {
        self.useIconsInTopBar = useIconsInTopBar
        self.text = text
        self.icon = icon
    }
    
    var body: some View {
        if useIconsInTopBar {
            Image(systemName: icon)
        } else {
            Text(text)
        }
    }
}
