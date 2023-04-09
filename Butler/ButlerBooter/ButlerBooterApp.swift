//
//  ButlerBooterApp.swift
//  ButlerBooter
//
//  Created by Aditya Saravana on 4/8/23.
//



import Cocoa

class ButlerBooterAppDelegate: NSObject, NSApplicationDelegate {
    struct Constants {
        static let mainAppBundleID = "com.devdude.Butler"
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Constants.mainAppBundleID
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            
            let applicationPathString = path as String
            guard let pathURL = URL(string: applicationPathString) else {return}
            NSWorkspace.shared.openApplication(at: pathURL, configuration: NSWorkspace.OpenConfiguration())
        }
    }
}
