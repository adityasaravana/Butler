//
//  SettingsButton.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/17/23.
//

import SwiftUI
import SettingsAccess
import Defaults

struct SettingsButton: View {
    @Default(.useIconsInTopBar) var useIconsInTopBar
    
    
    private func showSettings() {
        NSApp.activate(ignoringOtherApps: true)
        if #available(macOS 13, *) {
            
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }

    
    var body: some View {
        if useIconsInTopBar {
            if #available(macOS 14, *) {
                SettingsLink{
                    Image(systemName: "gear")
                }.keyboardShortcut(",", modifiers: .command)
            } else {
                Button { showSettings() } label: { Image(systemName: "gear") }
            }
        } else {
            if #available(macOS 14, *) {
                SettingsLink{
                    Text("Settings")
                }.keyboardShortcut(",", modifiers: .command)
            } else {
                Button("Settings") { showSettings() }
            }
        }
    }
}

