//
//  ButlerApp.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Cocoa
import SwiftUI
import AppKit
import Defaults
import KeyboardShortcuts

@main
struct ButlerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
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
        //        MenuBarExtra(content: {
        //            ContentView(windowSize: $windowSize).environmentObject(OpenAIConnector()).frame(width: windowWidth, height: windowHeight)
        //        }, label: {
        //            let image: NSImage = {
        //                let ratio = $0.size.height / $0.size.width
        //                $0.size.height = 18
        //                $0.size.width = 18 / ratio
        //                return $0
        //            }(NSImage(named: "MenuBarIcon")!)
        //
        //            Image(nsImage: image)
        //        }).menuBarExtraStyle(.window)
        //    }
//        WindowGroup {
//            ContentView(windowSize: $windowSize).environmentObject(OpenAIConnector()).frame(width: windowWidth, height: windowHeight)
//        }
        WindowGroup {}
    }
    
    //@NSApplicationMain
    class AppDelegate: NSObject, NSApplicationDelegate {
        
        var popover: NSPopover!
        var statusBarItem: NSStatusItem!
        
        func applicationDidFinishLaunching(_ aNotification: Notification) {
            if let window = NSApplication.shared.windows.first {
                    window.close()
                }
            // Create the SwiftUI view that provides the window contents.
            let contentView = ContentView(windowSize: .constant("sm")).environmentObject(OpenAIConnector())
            
            // Create the popover
            let popover = NSPopover()
            popover.contentSize = NSSize(width: 400, height: 500)
            popover.behavior = .transient
            popover.contentViewController = NSHostingController(rootView: contentView)
            self.popover = popover
            
            // Create the status item
            self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
            
            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "MenuBarIcon")
                button.action = #selector(togglePopover(_:))
            }
        }
        
        @objc func togglePopover(_ sender: AnyObject?) {
            if let button = self.statusBarItem.button {
                if self.popover.isShown {
                    self.popover.performClose(sender)
                } else {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                    self.popover.contentViewController?.view.window?.becomeKey()
                }
            }
        }
    }
    
    @MainActor
    final class AppState: ObservableObject {
        init() {
            KeyboardShortcuts.onKeyUp(for: .openButler) { [self] in
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
