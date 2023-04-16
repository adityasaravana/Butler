//
//  ButlerApp.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import SwiftUI
import AppKit


@main
struct ButlerApp: App {
    var body: some Scene {
        MenuBarExtra(content: {
            ContentView().environmentObject(OpenAIConnector()).frame(height: 600)
        }, label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                return $0
            }(NSImage(named: "MenuBarIcon")!)
            
            Image(nsImage: image)
        }).menuBarExtraStyle(.window)
    }
}

