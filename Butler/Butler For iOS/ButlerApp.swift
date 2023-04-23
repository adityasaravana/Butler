//
//  Butler_For_iOSApp.swift
//  Butler For iOS
//
//  Created by Aditya Saravana on 4/8/23.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct ButlerApp: App {
    
    init() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            //User has not indicated their choice for app tracking
            //You may want to show a pop-up explaining why you are collecting their data
            //Toggle any variables to do this here
        } else {
            ATTrackingManager.requestTrackingAuthorization { status in
                //Whether or not user has opted in initialize GADMobileAds here it will handle the rest
                
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OpenAIConnector())
        }
    }
}
