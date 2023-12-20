//
//  TopBarButtonLabel.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/17/23.
//

import SwiftUI
import Defaults

struct TopBarButtonLabel: View {
    @Default(.topBarButtonStyle) var topBarButtonStyle
    var text: String
    var icon: String
    var emoji: String
    
    init(text: String, icon: String, emoji: String) {
        self.text = text
        self.icon = icon
        self.emoji = emoji
    }
    
    var body: some View {
        switch topBarButtonStyle {
        case .text:
            Text(text)
        case .icons:
            Image(systemName: icon)
        case .emoji:
            Text(emoji)
        }
    }
}
