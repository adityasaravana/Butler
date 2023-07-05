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
import Foundation

struct ContentView: View {
    @State var epoch = 0
    
    @State var showErrorView = false
    @State var errorViewDescription = "Error"
    
    @State var textField = ""
    @Environment(\.openWindow) var openWindow
    
    @State var isLoading = false
    @State var showingHelpPopover = false
    
    @ObservedObject var connector: OpenAIConnector
    @Environment(\.requestReview) var requestReview
    
    @AppStorage(AppStorageNames.useIconsInTopBar.name) var useIconsInTopBar = false
    @AppStorage(AppStorageNames.messagesSent.name) var messagesSent: Int = 0
    
    func clearChat() {
        epoch += 1
        connector.clearMessageLog()
        isLoading = false
    }
    
    func showSettings() {
        NSApp.activate(ignoringOtherApps: true)
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Butler").bold()
                
                Spacer()
                
                if !useIconsInTopBar {
                    Button("Help") { showingHelpPopover = true }
                        .popover(isPresented: $showingHelpPopover) {
                            Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline).padding()
                        }
                    
                    Button("Clear Chat") { clearChat() }
                    Button("Settings") { showSettings() }
                    Button("Quit") { exit(0) }
                } else {
                    Button { showingHelpPopover = true } label: { Image(systemName: "questionmark") }
                        .popover(isPresented: $showingHelpPopover) {
                            Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline).padding()
                        }
                    
                    Button { clearChat() } label: { Image(systemName: "trash") }
                    Button { showSettings() } label: { Image(systemName: "gear") }
                    Button { exit(0) } label: { Image(systemName: "escape") }
                }
            }
            
            
            VStack {
                if connector.messageLog != [["role": "system", "content": "You're a friendly, helpful assistant"]] {
                    if !showErrorView {
                        ScrollView {
                            ForEach(connector.messageLog) { message in
                                if message["role"] != "system" {
                                    MessageView(message: message)
                                }
                            }
                            
                            if isLoading {
                                ProgressView("Loading...").padding(.top)
                            }
                        }
                        .padding()
                        .background(.thickMaterial)
                    } else {
                        ErrorView(debugDescription: errorViewDescription)
                    }
                } else {
                    ZStack {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Send a message")
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.thickMaterial)
                }
            }
            .cornerRadius(20)
            
            HStack {
                TextField("Type here", text: $textField, axis: .vertical)
                    .lineLimit(7)
                
                Button("Send") {
                    isLoading = true
                    Task {
                        if let appDelegate = AppDelegate.instance {
                            appDelegate.setIcon(name: "slowmo")
                        }
                    }
                    
                    
                    
                    connector.logMessage(textField, user: .user, epoch: epoch)
                    
                    
                    
                    
                    DispatchQueue.global().async {
                        
                            connector.sendToAssistant(epoch: epoch)
                        
                        
                        DispatchQueue.main.async {
                            isLoading = false
                            if let appDelegate = AppDelegate.instance {
                                appDelegate.resetIcon()
                            }
                            textField = ""
                        }
                    }
                    
                    if messagesSent >= 15 {
                        requestReview()
                    }
                    
                    
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isLoading)
            }
        }
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(connector: .shared)
    }
}
