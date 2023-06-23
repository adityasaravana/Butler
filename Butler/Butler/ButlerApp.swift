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
    
    
    var body: some Scene {
        WindowGroup {}
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(OpenAIConnector())
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            //                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "icondark", ofType: "png")!)
            button.image = NSImage(named: "MenuBrIcon")
            button.action = #selector(togglePopover(_:))
        }
    }
    
    @objc public func togglePopover(_ sender: AnyObject?) {
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

