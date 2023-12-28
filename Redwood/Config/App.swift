//
//  ButlerApp.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import SwiftUI
import AppKit
import KeyboardShortcuts
import Defaults
import SettingsAccess

@main
struct Redwood: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var copyLatestMessageAppState = CopyLatestMessageAppState()
    @StateObject private var openCloseButlerAppState = OpenCloseButlerAppState()
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var purchaseManager: PurchaseManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
        
        Window("MenuGPT Premium", id: "getpremium") {
            GetPremiumView()
                .padding()
                .environmentObject(purchaseManager)
                .environmentObject(entitlementManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}

extension NSImage.Name {
    static let menuBarIcon = NSImage.Name("MenuBarIcon")
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    static private(set) var instance: AppDelegate! = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.instance = self
        // Close any extra windows that pop up
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(connector: .shared).openSettingsAccess()
        
        // Create the popover
        let windowSize = Defaults[.windowSize]
        let popover = NSPopover()
        popover.contentSize = NSSize(width: windowSize.size.0, height: windowSize.size.1)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "mustache.fill", accessibilityDescription: nil)
            button.action = #selector(togglePopover(_:))
        }
    }
    
    public func updateWindowSize() {
        let contentView = ContentView(connector: .shared)
        let windowSize = Defaults[.windowSize]
        let popover = NSPopover()
        popover.contentSize = NSSize(width: windowSize.size.0, height: windowSize.size.1)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
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
    
    @objc public func showPopover() {
        if let button = self.statusBarItem.button {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.popover.contentViewController?.view.window?.becomeKey()
        }
    }
    
    @objc public func setIcon(name systemName: String) {
        let config = NSImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        self.statusBarItem.button?.image = NSImage(systemSymbolName: systemName, accessibilityDescription: nil)?.withSymbolConfiguration(config)
    }
    
    @objc public func resetIcon() {
        self.statusBarItem.button?.image = NSImage(systemSymbolName: "mustache.fill", accessibilityDescription: nil)
    }
}

@MainActor
final class OpenCloseButlerAppState: ObservableObject {
    init() {
        KeyboardShortcuts.onKeyUp(for: .openButler) {
            if let appDelegate = AppDelegate.instance {
                
                NSApp.activate(ignoringOtherApps: true)
                appDelegate.togglePopover(nil)
                
            } else {
                print("AppDelegate was nil")
            }
        }
    }
}

@MainActor
final class ClearChatAppState: ObservableObject {
    init() {
        KeyboardShortcuts.onKeyUp(for: .clearChat) {
            OpenAIConnector.shared.messages.deleteAll()
        }
    }
}

@MainActor
final class CopyLatestMessageAppState: ObservableObject {
    init() {
        KeyboardShortcuts.onKeyUp(for: .copyLatestMessage) {
            copyStringToClipboard(OpenAIConnector.shared.messages.last?.content ?? "Couldn't copy a message")
        }
    }
}


