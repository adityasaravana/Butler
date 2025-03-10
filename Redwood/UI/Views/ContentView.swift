// ORIGINAL CODE HAS BEEN COPIED TO CLIPBOARD
//
//  ContentView.swift
//  Butler For iOS
//
//  Created by Aditya Saravana on 4/8/23.
//

import SwiftUI
import MarkdownUI
import StoreKit
import Defaults
import SettingsAccess

struct ContentView: View {
    enum ScrollPosition: Hashable {
        case image(index: Int)
    }
    
    @State var textField = ""
    @State var isLoading = false
    @State var showingHelpPopover = false
    @State var showingChatHistory = false
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    
    @ObservedObject var connector: OpenAIConnector
    
    @Default(.messagesSent) var messagesSent
    @Default(.chats) var chats
    @Default(.hideHelpButton) var hideHelpButton
    
    func clearChat() {
        connector.messages.deleteAll()
        isLoading = false
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(Bundle.main.displayName!).bold()
                
                Spacer()
                if !hideHelpButton {
                    Button { showingHelpPopover = true } label: { TopBarButtonLabel(text: "Help", icon: "questionmark", emoji: "🤨") }
                        .popover(isPresented: $showingHelpPopover) {
                            HelpView()
                        }
                }
                
                Button {
                    showingChatHistory = true
                } label: {
                    TopBarButtonLabel(text: "History", icon: "clock.fill", emoji: "🕘")
                }.popover(isPresented: $showingChatHistory) {
                    ChatHistoryView(connector: connector)
                }.disabled(chats == [:])
                
                Button { clearChat() } label: { TopBarButtonLabel(text: "Clear Chat", icon: "trash.fill", emoji: "🗑️") }
                
                SettingsButton()
                
                Button { exit(0) } label: { TopBarButtonLabel(text: "Quit", icon: "escape", emoji: "💨") }
                
            }
            
            VStack {
                if !connector.messages.messagesEmpty {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack {
                                ForEach(connector.messages) { message in
                                    MessageView(message: message)
                                }
                                
                                if isLoading {
                                    ProgressView("Loading...").padding(.top)
                                }
                            }
                        }
                        .onChange(of: connector.messages) { _ in
                            withAnimation {
                                proxy.scrollTo(connector.messages.last)
                            }
                        }
                    }
                    
                } else {
                    ZStack {
                        Filler()
                        Text("Send a message")
                    }
                }
            }
            .padding()
            .background(.ultraThickMaterial)
            .cornerRadius(9)
            
            
            HStack {
                TextField("Type here", text: $textField)
                
                .textFieldStyle(.roundedBorder)
                .lineLimit(7)
                
                Button("Send") {
                    connector.logMessage(textField, user: .user)
                    isLoading = true
                    
                    Task {
                        if let appDelegate = AppDelegate.instance {
                            appDelegate.setIcon(name: "slowmo")
                        }
                    }
                    
                    
                    
                    Task {
                        await connector.sendToAssistant()
                        isLoading = false
                        if let appDelegate = AppDelegate.instance {
                            appDelegate.resetIcon()
                        }
                        textField = ""
                    }
                    
                    if messagesSent >= Constants.messagesRequiredForRequestingReview {
                        requestReview()
                        messagesSent = 0
                    }
                }
                .disabled(isLoading)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .onAppear {
            if !Defaults[.chats].isEmpty && !Defaults[.lastChatID].isNil {
                connector.messages = Defaults[.chats][Defaults[.lastChatID]!]!
            }
        }
    }
}

#Preview {
    ContentView(connector: .shared)
}
