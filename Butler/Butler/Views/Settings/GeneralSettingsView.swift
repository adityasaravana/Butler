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
    
    @Default(.highlightSyntax) var highlightSyntax
    @Default(.fontSize) var fontSize
    @Default(.useIconsInTopBar) var useIconsInTopBar
    @Default(.windowSize) var windowSize
    @Default(.textFieldLineLimit) var textFieldLineLimit
    
    var body: some View {
        List {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            Divider()
            Toggle("Use icons for buttons", isOn: $useIconsInTopBar)
            Divider()
            
            //            HStack {
            //                HStack {
            //                    Image(systemName: "wrench.and.screwdriver.fill")
            //                    Text("BETA")
            //                }.bold()
            //                .padding(10)
            //                .background(.red)
            //                .cornerRadius(25)
            //                Toggle("Enable Syntax Highlighting", isOn: $highlightSyntax)
            //            }
            
            Stepper("Text Field Line Limit: \(textFieldLineLimit)", value: $textFieldLineLimit)
            
            Divider()
            
            Picker("Window Size", selection: $windowSize) {
                ForEach(AppWindowSize.allCases) { size in
                    Text(size.name)
                }
            }
            
            Divider()
            
            FontSizeSliderView(padding: false, step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
            
        }
        .listStyle(.plain)
        .onChange(of: windowSize) { newValue in
            AppDelegate.instance.updateWindowSize()
        }
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}

