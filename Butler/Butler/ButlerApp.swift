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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#warning("Xcode 14 required")
//@main
//struct UtilityApp: App {
//    var body: some Scene {
//        MenuBarExtra("Utility App", systemImage: "hammer") {
//            ContentView()
//        }
//    }
//}

