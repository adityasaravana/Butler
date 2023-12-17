//
//  Changelog.swift
//  Butler
//
//  Created by Aditya Saravana on 7/20/23.
//

import Foundation

fileprivate let appVersionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

public struct Changelog {
    static var notes = """
    Hey there! Butler just had a major update, and you might not have noticed all the new features it has. Here's a couple of the big ones.
    
    - Butler's settings are now in their own window, with two important new tabs that'll make using ChatGPT even more convenient.
    - Hotkeys are here! Open settings to assign hotkeys to open and close Butler no matter what you're doing, clear chat, and copy the latest message in chat.
    - You can now use OpenAI's latest model, GPT-4, in Butler, if you've applied for early access to the GPT-4 API. You can switch between models in the ChatGPT tab of the new settings window.
    - For users who need more screen real estate, Butler now features customizable window size. Check out the general tab in settings to try it.
    
    You can read the complete changelog in Butler's new settings window.
    
    Thanks for using Butler!
    - Aditya
    """
    
    static var changelog = """
    Using the awesome feedback you guys have given me, I refined Butler to make it even easier to access ChatGPT.
    
    VERSION \(appVersionNumber):
    
    New Features:
    - Hotkeys! Open and close Butler, clear chat, and copy the latest message in chat using your keyboard, even when Butler's closed!
    - Support for GPT-4!
    - Window size customization!

    More New Features:
    - The icon changes to a loading indicator while waiting for a response from ChatGPT.
    - Launch at login
    - Ability to change the text on the buttons in the chat view to icons
    - Syntax highlighting (beta)
    - Added a slider to change the temperature (creativity) of ChatGPT
    - Change the max line limit of the chat view's text field
    
    Changes:
    - New icon! Butler's just a mustache, to make it easier to see on the menu bar.
    - Moved settings to its own window to make the chat window cleaner and fit in better with MacOS
    - Got rid of the yellow accent to make reading messages easier

    Bug Fixes:
    - Fixed an issue where messages would be sent to OpenAI with missing context
    - Lots more bug fixes and performance improvements.
    
    """
}
