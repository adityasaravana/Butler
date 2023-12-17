//
//  SettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/22/23.
//

import SwiftUI
import KeyboardShortcuts


struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Image(systemName: "gearshape").imageScale(.large)
                    Text("General")
                }
            HotkeySettingsView()
                .tabItem {
                    Image(systemName: "command").imageScale(.large)
                    Text("Hotkeys")
                }
            
            ChatGPTSettingsView()
                .tabItem {
                    Image(systemName: "globe").imageScale(.large)
                    Text("ChatGPT")
                }
        }.frame(width: 400, height: 200)
    }
}

#Preview {
    SettingsView()
}

