//
//  CopyStringToClipboard.swift
//  Butler For iOS
//
//  Created by Aditya Saravana on 4/8/23.
//

import Foundation
import SwiftUI

public func copyStringToClipboard(_ string: String) {
#if os(macOS)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(string, forType: .string)
#else
    UIPasteboard.general.string = string
#endif
}
