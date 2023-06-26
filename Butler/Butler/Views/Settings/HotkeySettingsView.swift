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
            KeyboardShortcuts.Recorder("Open Butler", name: .openButler)
        }.frame(width: 400, height: 150)
    }
}

struct HotkeySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeySettingsView()
    }
}
