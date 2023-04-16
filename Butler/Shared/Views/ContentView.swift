//
//  ContentView.swift
//  Butler For iOS
//
//  Created by Aditya Saravana on 4/8/23.
//

import SwiftUI

#if os(iOS)
import GoogleMobileAds
#endif

struct ContentView: View {
    @State var textField = ""
    @EnvironmentObject var connector: OpenAIConnector
    @State var isLoading = false
    let dataManager = DataManager()
    var body: some View {
        VStack {
            HStack {
                Text("Butler").bold().padding()
                Menu("Settings") {
                    Button("Clear Chat") { connector.clearMessageLog() }
                    
                    Button("Set As OpenAI API Key") {
                        dataManager.push(key: .Butler_UserOpenAIKey, content: textField.filter { !" \n\t\r".contains($0) })
                        textField = ""
                    }
                    
                }
                
#if os(macOS)
                Button("Quit") { exit(0) }.padding()
#endif
            }
            
            Divider()
            
            ScrollView {
                ForEach(connector.messageLog) { message in
                    if message["role"] != "system" {
                        MessageView(message: message)
                    }
                }
                
                if isLoading {
                    ProgressView("Loading...").padding()
                }
            }
            
            Divider()
            
            HStack {
                TextField("Type here", text: $textField)
                Button("Send") {
                    connector.logMessage(textField, messageUserType: .user)
                    isLoading = true
                    
//                    DispatchQueue.global(priority: .high).async {
//                        connector.sendToAssistant()
//                        DispatchQueue.main.async {
//                            isLoading = false
//                        }
//                    }
                    
                    DispatchQueue.global().async {
                        connector.sendToAssistant()
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                  
                    textField = ""
                }.keyboardShortcut(.defaultAction)
            }
#if os(iOS)
            SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-5488373209303539/4357719195")
#endif
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(OpenAIConnector())
    }
}

struct MessageView: View {
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
                Text(message["content"] ?? "error")
                    .padding(.all, 15)
                    .foregroundColor(Color.white)
                    .background(messageColor)
            }
            
            if message["role"] == "assistant" {
                Button("Copy") {
                    copyStringToClipboard(message["content"] ?? "error")
                }
                Spacer()
            }
        }
    }
}

