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
import Defaults

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
    
    @Default(.useIconsInTopBar) var useIconsInTopBar
    @Default(.messagesSent) var messagesSent
    @Default(.showNewFeatures) var showNewFeatures
    
    func clearChat() {
        connector.deleteAll()
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
    
    var topBarView: some View {
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
    }
    var textFieldView: some View {
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
                    connector.sendToAssistant()
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
            .keyboardShortcut(.defaultAction)
            .disabled(isLoading)
        }
    }
    
    var body: some View {
        VStack {
            topBarView
            
            VStack {
                if !connector.messagesEmpty {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack {
                                ForEach(connector.messages, id: \.id) { message in
                                    if message["role"] != "system" {
                                        MessageView(message: message)
                                    }
                                }
                                
                                if isLoading {
                                    ProgressView("Loading...").padding(.top)
                                }
                            }
                        }.onChange(of: connector.messages, perform: { _ in
                            withAnimation {
                                proxy.scrollTo(connector.messages.last?.id)
                            }
                        })
                        
                        
                    }
                    .padding()
                    .background(.thickMaterial)
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
            
            textFieldView
        }
        .padding()
        .alert(Changelog.notes, isPresented: $showNewFeatures) {
            Button("Cool!", role: .cancel) {
                showNewFeatures = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(connector: .shared)
    }
}
