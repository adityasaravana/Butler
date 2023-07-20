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
            
            ChangelogView()
                .tabItem {
                    Image(systemName: "star").imageScale(.large)
                    Text("What's New")
                }
        }.frame(width: 400, height: 200)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

