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
    @Default(.textFieldLineLimit) var textFieldLineLimit
    
    var body: some View {
        List {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            Toggle("Use icons for buttons", isOn: $useIconsInTopBar)
            
            Stepper("Text Field Line Limit: \(textFieldLineLimit)", value: $textFieldLineLimit)
            
            
            Picker("Window Size", selection: $windowSize) {
                ForEach(AppWindowSize.allCases) { size in
                    Text(size.name)
                }
            }
            
            
            FontSizeSliderView(padding: false, step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
            
        }
        .listStyle(.plain)
        .onChange(of: windowSize) { newValue in
            AppDelegate.instance.updateWindowSize()
        }
    }
}

#Preview {
    GeneralSettingsView()
}

