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
    @Default(.topBarButtonStyle) var topBarButtonStyle
    
    
    private func showSettings() {
        NSApp.activate(ignoringOtherApps: true)
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    var body: some View {
        switch topBarButtonStyle {
        case .icons:
            if #available(macOS 14, *) {
                SettingsLink{
                    Image(systemName: "gear")
                }
                .keyboardShortcut(",", modifiers: .command)
                .onTapGesture {
                    NSApp.activate(ignoringOtherApps: true)
                }
            } else {
                Button { showSettings() } label: { Image(systemName: "gear") }
            }
        case .text:
            if #available(macOS 14, *) {
                SettingsLink{
                    Text("Settings")
                }
                .keyboardShortcut(",", modifiers: .command)
                .onTapGesture {
                    NSApp.activate(ignoringOtherApps: true)
                }
            } else {
                Button("Settings") { showSettings() }
            }
        case .emoji:
            if #available(macOS 14, *) {
                SettingsLink{
                    Text("⚙️")
                }.keyboardShortcut(",", modifiers: .command)
            } else {
                Button("⚙️") { showSettings() }
            }
        }
    }
}

