//
//  HotkeySettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI
import KeyboardShortcuts

struct HotkeySettingsView: View {
    var body: some View {
        List {
            KeyboardShortcuts.Recorder("Open/Close \(Bundle.main.displayName!)", name: .openButler)
            KeyboardShortcuts.Recorder("Clear Chat", name: .clearChat)
            KeyboardShortcuts.Recorder("Copy Latest Message", name: .copyLatestMessage)
        }
    }
}

#Preview {
    HotkeySettingsView()
}
