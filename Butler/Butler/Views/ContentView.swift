//
//  ContentView.swift
//  Butler For iOS
//
//  Created by Aditya Saravana on 4/8/23.
//

import SwiftUI
import MarkdownUI
import Defaults
import StoreKit

fileprivate enum WindowSizeUserPreferenceLocal {
    case small
    case medium
    case large
}

struct ContentView: View {
    @State var textField = ""
    
    @State var isLoading = false
    @State var showingSettings = false
    @State var viewUpdater = UUID()
    @State fileprivate var selectedWindowSizeLocal: WindowSizeUserPreferenceLocal = .medium
    
    @State var showingHelpPopover = false
    
    @EnvironmentObject var connector: OpenAIConnector
    @Environment(\.requestReview) var requestReview
    
    @State var fontSize = CGFloat(Defaults[.fontSize])
    @Binding var windowSize: String
    
    
    
    var showHideSettingString: String {
        if showingSettings {
            return "Hide Settings"
        } else {
            return "Show Settings"
        }
    }
    
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
                Button(showHideSettingString) {
                    withAnimation {
                        if showingSettings {
                            showingSettings = false
                        } else {
                            showingSettings = true
                        }
                    }
                    
                }
                
                
                Button("Quit") { exit(0) }
                
            }
            
            if connector.messageLog != [["role": "system", "content": "You're a friendly, helpful assistant"]] {
                ScrollView {
                    ForEach(connector.messageLog) { message in
                        if message["role"] != "system" {
                            MessageView(fontSize: $fontSize, message: message)
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
                    
                    if Defaults[.messagesSuccessfullySent] >= 15 {
                        requestReview()
                    }
                    
                    textField = ""
                }.keyboardShortcut(.defaultAction)
            }
            
            if showingSettings {
                SettingsView(fontSize: $fontSize)
                
            }
        }
        .padding()
    }
}
