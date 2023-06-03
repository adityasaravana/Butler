//
//  MessageView.swift
//  Butler
//
//  Created by Aditya Saravana on 4/30/23.
//

import SwiftUI
import MarkdownUI

struct MessageView: View {
    @Binding var fontSize: CGFloat
    var message: [String: String]
    
    var messageColor: Color {
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
    
    var body: some View {
        HStack {
            if message["role"] == "user" {
                Spacer()
            }
            
            ChatBubble(direction: bubbleDirection) {
                Markdown(message["content"] ?? "error")
                    .padding(.all, 15)
                    .markdownTextStyle(\.text) {
                        ForegroundColor(.white)
                        FontSize(fontSize)
                    }
                    .background(messageColor)
                    .textSelection(.enabled)
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
