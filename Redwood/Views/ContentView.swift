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
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    
    @ObservedObject var connector: OpenAIConnector
    
    
    @Default(.messagesSent) var messagesSent
    
    func clearChat() {
        connector.messages.deleteAll()
        isLoading = false
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Butler").bold()
                
                Spacer()
                
                Button { showingHelpPopover = true } label: { TopBarButtonLabel(text: "Help", icon: "questionmark") }
                    .popover(isPresented: $showingHelpPopover) {
                        Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline).padding()
                    }
                
                Button { clearChat() } label: { TopBarButtonLabel(text: "Clear Chat", icon: "trash.fill") }
                
                SettingsButton()
                
                Button { exit(0) } label: { TopBarButtonLabel(text: "Quit", icon: "escape") }
                
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
                        .onChange(of: connector.messages, perform: { _ in
                            withAnimation {

                                proxy.scrollTo(connector.messages.last)
                            }
                        })
                    }
                    
                } else {
                    ZStack {
                        Text("Send a message")
                    }
                    .scaledToFill()
                    
                }
            }
            .cornerRadius(10)
            .padding()
            .background(.thickMaterial)
            
            
            HStack {
                TextField("Type here", text: $textField, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(7)
                
                Button("Send") {
                    isLoading = true
                    
                    Task {
                        if let appDelegate = AppDelegate.instance {
                            appDelegate.setIcon(name: "slowmo")
                        }
                    }
                    
                    connector.logMessage(textField, user: .user)
                    
                    Task {
                        await connector.sendToAssistant()
                        isLoading = false
                        if let appDelegate = AppDelegate.instance {
                            appDelegate.resetIcon()
                        }
                        textField = ""
                    }
                    
                    if messagesSent >= 15 {
                        requestReview()
                    }
                }
                .disabled(isLoading)
                .keyboardShortcut(.defaultAction)
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView(connector: .shared)
}
