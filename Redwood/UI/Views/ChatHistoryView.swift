//
//  ChatHistoryView.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/20/23.
//

import SwiftUI
import Defaults
import OpenAIKit

struct ChatHistoryView: View {
    @ObservedObject var connector: OpenAIConnector
    @Default(.chats) var chats
    
    @State var showDeleteConfirmation = false
    @State var showDeleteAllChatsConfirmation = false
    var body: some View {
        List {
            ForEach(Array(chats.keys), id: \.self) { id in
                HStack {
                    Text(chats[id]?.last?.content ?? "").lineLimit(1)
                    Spacer()
                    Button("Load") {
                        if let chatToLoad = chats[id] {
                            connector.messages = chatToLoad
                        }
                    }
                    Button("Delete") {
                        showDeleteConfirmation = true
                    }.alert("You sure?", isPresented: $showDeleteConfirmation) {
                        Button("Yeah", role: .destructive) {
                            chats.removeValue(forKey: id)
                        }
                        
                        Button("Nevermind", role: .cancel) {}
                    }
                }
                .padding(.horizontal)
            }
            HStack {
                Spacer()
                Button("Delete All") {
                    showDeleteAllChatsConfirmation = true
                }.alert("You sure?", isPresented: $showDeleteAllChatsConfirmation) {
                    Button("Yeah", role: .destructive) {
                        chats = [:]
                    }
                    
                    Button("Nevermind", role: .cancel) {}
                }
                Spacer()
            }
        }
    }
}

struct ChatRow: View {
    var chat: [Chat.Message]
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    ChatHistoryView(connector: .shared)
}
