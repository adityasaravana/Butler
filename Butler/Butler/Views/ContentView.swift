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

fileprivate enum WindowSizeUserPreferenceLocal {
    case small
    case medium
    case large
}

struct ContentView: View {
    @State var textField = ""
    @Environment(\.openWindow) var openWindow
    @State var isLoading = false
    @State var showingSettings = false
    @State var viewUpdater = UUID()
    @State fileprivate var selectedWindowSizeLocal: WindowSizeUserPreferenceLocal = .medium
    
    @State var showingHelpPopover = false
    
    @EnvironmentObject var connector: OpenAIConnector
    @Environment(\.requestReview) var requestReview
    
    
    @AppStorage("messagesSent") var messagesSent: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Butler").bold()
                
                
                Spacer()
                
                Button("Help") {
                    showingHelpPopover = true
                }
                .popover(isPresented: $showingHelpPopover) {
                    Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline).padding()
                }
                
                Button("Clear Chat") { connector.clearMessageLog() }
                Button("Open Settings") {
                                let settingsWindow = NSWindow(
                                    contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                                    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                                    backing: .buffered,
                                    defer: false
                                )
                                settingsWindow.center()
                                settingsWindow.contentView = NSHostingView(rootView: SettingsView())
                                settingsWindow.makeKeyAndOrderFront(nil)
                                NSApp.activate(ignoringOtherApps: true)
                            }
                
                
                Button("Quit") { exit(0) }
                
            }
            
            if connector.messageLog != [["role": "system", "content": "You're a friendly, helpful assistant"]] {
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
                .cornerRadius(20)
            } else {
                ZStack {
                    Text("Send a message")
                }
                .padding()
                .background(.thickMaterial)
                .cornerRadius(20)
            }
            
            HStack {
                TextField("Type here", text: $textField, axis: .vertical).lineLimit(7)
                
                Button("Send") {
                    connector.logMessage(textField, messageUserType: .user)
                    isLoading = true
                    
                    DispatchQueue.global().async {
                        connector.sendToAssistant()
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                    
                    if messagesSent >= 15 {
                        requestReview()
                    }
                    
                    textField = ""
                }.keyboardShortcut(.defaultAction)
            }
            
            if showingSettings {
//                SettingsView(fontSize: $fontSize)
                SettingsView()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(OpenAIConnector())
    }
}
