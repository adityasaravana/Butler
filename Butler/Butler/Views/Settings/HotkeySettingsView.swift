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
        VStack {
            KeyboardShortcuts.Recorder("Open/Close Butler", name: .openButler)
            KeyboardShortcuts.Recorder("Clear Chat", name: .clearChat)
            KeyboardShortcuts.Recorder("Copy Latest Message", name: .copyLatestMessage)
        }
    }
}

struct HotkeySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeySettingsView()
    }
}
