//
//  ButlerApp.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import SwiftUI
import AppKit
import Defaults


@main
struct ButlerApp: App {
    @State var windowSize = "Will add support for windowSize soon."
    
    var windowWidth: CGFloat {
        if windowSize == "small" {
            return 350
        } else if windowSize == "medium" {
            return 600
        } else if windowSize == "large" {
            return 1000
        } else {
            return 600
        }
    }
    
    var windowHeight: CGFloat {
        if windowSize == "small" {
            return 450
        } else if windowSize == "medium" {
            return 750
        } else if windowSize == "large" {
            return 1200
        } else {
            return 750
        }
    }
    
    var body: some Scene {
        MenuBarExtra(content: {
            ContentView(windowSize: $windowSize).environmentObject(OpenAIConnector()).frame(width: windowWidth, height: windowHeight)
        }, label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                return $0
            }(NSImage(named: "MenuBarIcon")!)
            
            Image(nsImage: image)
        }).menuBarExtraStyle(.window)
        
        Window("Butler - Standalone Window", id: "standalone_chat_window") {
            ContentView(windowSize: $windowSize).environmentObject(OpenAIConnector()).frame(width: windowWidth, height: windowHeight)
        }
    }
    
    
}

