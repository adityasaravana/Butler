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
import OpenAIKit

struct MessageView: View {
    @Default(.fontSize) var fontSize
    @Default(.highlightSyntax) var highlightSyntax
    @Environment(\.colorScheme) private var colorScheme
    
    var message: Chat.Message
    
    var messageColor: SwiftUI.Color {
        
        switch message {
        case .system:
            return .red
        case .user:
            return .accentColor
        case .assistant:
            return .gray
        }
    }
    
    var bubbleDirection: ChatBubbleShape.Direction {
        switch message {
        case .system:
            return .right
        case .user:
            return .right
        case .assistant:
            return .left
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
            if bubbleDirection == .right {
                Spacer()
                Button("Copy") {
                    copyStringToClipboard(message.content)
                }.font(.system(size: fontSize))
            
                
            }
            
            ChatBubble(direction: bubbleDirection) {
                if highlightSyntax {
                    Markdown(message.content)
                        .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
                        .padding(.all, 15)
                        .markdownTextStyle(\.text) {
                            ForegroundColor(.white)
                            FontSize(fontSize)
                        }
                        .background(messageColor)
                        .textSelection(.enabled)
                } else {
                    Markdown(message.content)
                        .padding(.all, 15)
                        .markdownTextStyle(\.text) {
                            ForegroundColor(.white)
                            FontSize(fontSize)
                        }
                        .background(messageColor)
                        .textSelection(.enabled)
                }
            }
            
            if bubbleDirection == .left {
                Button("Copy") {
                    copyStringToClipboard(message.content)
                }.font(.system(size: fontSize))
                Spacer()
            }
        }
    }
}
