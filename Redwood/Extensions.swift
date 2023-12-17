//
//  Extensions.swift
//  Butler
//
//  Created by Aditya Saravana on 12/16/23.
//

import Foundation
import SwiftUI
import OpenAIKit
import Defaults

// MARK: View.if
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: Clear Backgrounds for NSTextView
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

// MARK: copyStringToClipboard
public func copyStringToClipboard(_ string: String) {
#if os(macOS)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(string, forType: .string)
#else
    UIPasteboard.general.string = string
#endif
}

// MARK: OpenAIKit Compatibility
extension Chat.Message: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .user(let value):
            hasher.combine(value) // combine with associated value, if it's not `Hashable` map it to some `Hashable` type and then combine result
        case .assistant(let value):
            hasher.combine(value) // combine with associated value, if it's not `Hashable` map it to some `Hashable` type and then combine result
        case .system:
            // you can `combine` with some `Hashable` constant, but here it's ok just to skip
            break
        }
    }
}

extension Chat.Message: Equatable {
    public static func == (lhs: Chat.Message, rhs: Chat.Message) -> Bool {
        switch (lhs, rhs) {
        case (.user, .user), (.assistant, .assistant), (.system, .system):
            return true
        default:
            return false
        }
    }
}

extension Chat.Message: Identifiable {
    public var id: Self { self }
}


// MARK: Dictionary, Array, String + Identifiable
extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }


