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
    @Default(.useIconsInTopBar) var useIconsInTopBar
    @Default(.windowSize) var windowSize
    var body: some View {
        VStack {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            Toggle("Use icons in top bar", isOn: $useIconsInTopBar)
            
            Picker("Window Size", selection: $windowSize) {
                ForEach(AppWindowSize.allCases) { size in
                    Text(size.name)
                }
            }.padding(.horizontal)
            
            
            FontSizeSliderView(padding: true, step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
        }
        .onChange(of: windowSize) { newValue in
            AppDelegate.instance.updateWindowSize()
        }
        
    }
}

private struct Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}

