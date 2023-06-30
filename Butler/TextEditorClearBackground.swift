//
//  TextEditorClearBackground.swift
//  Butler
//
//  Created by Aditya Saravana on 6/28/23.
//

import SwiftUI

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
