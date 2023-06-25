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
            Text("Hotkeys")
                .frame(width: 400, height: 150)
                .tabItem {
                    Image(systemName: "stop.circle").imageScale(.large)
                    Text("Filters")
                }
            
            ChatGPTSettingsView()
                .tabItem {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                    Text("Search")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

