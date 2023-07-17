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
    var body: some View {
        ScrollView {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            
            Toggle("Use icons in top bar", isOn: $useIconsInTopBar)
            HStack {
                HStack {
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("BETA")
                }.bold()
                .padding(10)
                .background(.red)
                .cornerRadius(25)
                Toggle("Enable Syntax Highlighting", isOn: $highlightSyntax)
            }
            
            
            Picker("Window Size", selection: $windowSize) {
                ForEach(AppWindowSize.allCases) { size in
                    Text(size.name)
                }
            }.padding(.horizontal)
            
            
            FontSizeSliderView(padding: true, step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
        }
        .padding()
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

