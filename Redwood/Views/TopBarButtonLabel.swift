//
//  TopBarButtonLabel.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/17/23.
//

import SwiftUI
import Defaults

struct TopBarButtonLabel: View {
    @Default(.useIconsInTopBar) var useIconsInTopBar
    var text: String
    var icon: String
    
    init(text: String, icon: String) {
        
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
