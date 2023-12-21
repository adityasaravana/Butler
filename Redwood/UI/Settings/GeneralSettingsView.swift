//
//  GeneralTabView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI
import LaunchAtLogin
import Defaults

struct GeneralSettingsView: View {
    @Default(.fontSize) var fontSize
    @Default(.topBarButtonStyle) var topBarButtonStyle
    @Default(.windowSize) var windowSize
    @Default(.enableChatDeletionConfirmation) var enableChatDeletionConfirmation
    var body: some View {
        List {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            Picker("Top Bar Buttons", selection: $topBarButtonStyle) {
                ForEach(TopBarButtonsStyle.allCases, id: \.self) {
                    Text($0.name)
                }
            }
            .pickerStyle(.segmented)

            Picker("Window Size", selection: $windowSize) {
                ForEach(AppWindowSize.allCases) { size in
                    Text(size.name)
                }
            }
            
            
            FontSizeSliderView(padding: false, step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
            
            Toggle("Ask For Confirmation When Deleting Chats", isOn: $enableChatDeletionConfirmation)
            
        }
        .onChange(of: windowSize) { newValue in
            AppDelegate.instance.updateWindowSize()
        }
    }
}

#Preview {
    GeneralSettingsView()
}

