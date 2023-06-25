//
//  GeneralTabView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI
import LaunchAtLogin

struct GeneralSettingsView: View {
    @AppStorage(AppStorageNames.fontSize.name) var fontSize: Double = 12.0
   
    var body: some View {
        VStack {
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            FontSizeSliderView(step: 3, text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
        }
        .frame(width: 400, height: 150)
        .padding()
    }
}

private struct Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}

