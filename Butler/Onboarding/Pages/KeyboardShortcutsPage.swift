//
//  KeyboardShortcutsPage.swift
//  Afterburner 
//
//  Created by Aditya Saravana on 7/25/23.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutsPage: View {
    @Binding var disableNextButton: Bool
    var body: some View {
        VStack {
            Image(systemName: "keyboard")
                .font(.system(size: 128))
                .padding()
            Text("Choose Your Hotkeys")
                .bold()
                .font(.largeTitle)
                .padding(.bottom, 10)
            Text("You can set keybinds to open the Butler menu bar app, clear chat, and copy the latest message in chat, no matter where you are and what windows you have open.")
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding(.bottom, 30)
            
            List {
                KeyboardShortcuts.Recorder("Open/Close Butler", name: .openButler)
                KeyboardShortcuts.Recorder("Clear Chat", name: .clearChat)
                KeyboardShortcuts.Recorder("Copy Latest Message", name: .copyLatestMessage)
            }.cornerRadius(20)
        }
        .padding()
        .modifier(OnboardingViewPage())
        .onAppear { disableNextButton = false }
    }
}

struct KeyboardShortcutsPage_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardShortcutsPage(disableNextButton: .constant(false))
    }
}
