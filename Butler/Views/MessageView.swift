//
//  MessageView.swift
//  Butler
//
//  Created by Aditya Saravana on 4/30/23.
//

import SwiftUI
import MarkdownUI
import Splash
import Defaults

struct MessageView: View {
    @Default(.fontSize) var fontSize
    @Default(.highlightSyntax) var highlightSyntax
    @Environment(\.colorScheme) private var colorScheme
    
    var message: [String: String]
    
    var messageColor: SwiftUI.Color {
        if message["role"] == "user" {
            return .gray
        } else if message["role"] == "assistant" {
            return .accentColor
        } else {
            return .red
        }
    }
    
    var bubbleDirection: ChatBubbleShape.Direction {
        if message["role"] == "user" {
            return .right
        } else if message["role"] == "assistant" {
            return .left
        } else {
            return .right
        }
    }
    
    private var theme: Splash.Theme {
        // NOTE: We are ignoring the Splash theme font
        switch self.colorScheme {
        case .dark:
            return .wwdc17(withFont: .init(size: 16))
        default:
            return .wwdc17(withFont: .init(size: 16))
        }
    }
    
    var body: some View {
        HStack {
            if message["role"] == "user" {
                Spacer()
                Button("Copy") {
                    copyStringToClipboard(message["content"] ?? "error")
                }.font(.system(size: fontSize))
            }
            
            ChatBubble(direction: bubbleDirection) {
                if highlightSyntax {
                    Markdown(message["content"] ?? "error")
                        .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
                        .padding(.all, 15)
                        .markdownTextStyle(\.text) {
                            ForegroundColor(.white)
                            FontSize(fontSize)
                        }
                        .background(messageColor)
                        .textSelection(.enabled)
                } else {
                    Markdown(message["content"] ?? "error")
                        .padding(.all, 15)
                        .markdownTextStyle(\.text) {
                            ForegroundColor(.white)
                            FontSize(fontSize)
                        }
                        .background(messageColor)
                        .textSelection(.enabled)
                }
            }
            
            if message["role"] == "assistant" {
                Button("Copy") {
                    copyStringToClipboard(message["content"] ?? "error")
                }.font(.system(size: fontSize))
                Spacer()
            }
        }
    }
}
