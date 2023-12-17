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
    
    @Default(.useIconsInTopBar) var useIconsInTopBar
    @Default(.messagesSent) var messagesSent
    @Default(.showNewFeatures) var showNewFeatures
    @Default(.onboard) var onboard
    
    func clearChat() {
        connector.deleteAll()
        isLoading = false
    }
    
    func showSettings() {
        NSApp.activate(ignoringOtherApps: true)
        if #available(macOS 13, *) {
            
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
                if #available(macOS 14, *) {
                    SettingsLink{
                        Text("Settings")
                    }.keyboardShortcut(",", modifiers: .command)
                } else {
                    Button("Settings") { showSettings() }
                }
                Button("Quit") { exit(0) }
            } else {
                Button { showingHelpPopover = true } label: { Image(systemName: "questionmark") }
                    .popover(isPresented: $showingHelpPopover) {
                        Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline).padding()
                    }
                
                Button { clearChat() } label: { Image(systemName: "trash") }
                if #available(macOS 14, *) {
                    SettingsLink{
                        Image(systemName: "gear")
                    }.keyboardShortcut(",", modifiers: .command)
                } else {
                    Button { showSettings() } label: { Image(systemName: "gear") }
                }
                
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
    
    var body: some View {
        VStack {
            topBarView
            
            VStack {
                
                if !connector.messagesEmpty && !onboard {
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
                        }.onChange(of: connector.messages, perform: { _ in
                            withAnimation {
                                proxy.scrollTo(connector.messages.last)
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
                                if !onboard {
                                    Text("Send a message")
                                } else {
                                    Text("Why not finish setting up Butler first?")
                                    HStack {
                                        Button("No thanks, I'll figure it out.") {
                                            withAnimation {
                                                onboard = false
                                            }
                                        }
                                        Button("Show me the setup window.") {
                                            NSApp.windows.first?.makeKeyAndOrderFront(self)
                                            NSApplication.shared.activate(ignoringOtherApps: true)
                                        }
                                    }
                                }
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
            
            if !onboard {
                textFieldView
            }
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
