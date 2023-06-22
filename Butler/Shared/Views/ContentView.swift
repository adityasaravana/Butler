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
    @State var openAIKeyLocal = ""
    @State var isLoading = false
    @State var showingSettings = false
    @State var viewUpdater = UUID()
    @State fileprivate var selectedWindowSizeLocal: WindowSizeUserPreferenceLocal = .medium
    
    @State var showingHelpPopover = false
    
    @EnvironmentObject var connector: OpenAIConnector
    @Environment(\.requestReview) var requestReview
    
    @State var fontSize = CGFloat(Defaults[.fontSize])
    @Binding var windowSize: String
    
    let dataManager = DataManager()
    
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
                Text("Butler").bold().padding([.top, .bottom, .trailing])
                
                
                Spacer()
                
                Button("Help") {
                    showingHelpPopover = true
                }
                .popover(isPresented: $showingHelpPopover) {
                    EmailForHelpText().padding()
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
                .background(.thinMaterial)
                .cornerRadius(20)
            } else {
                ZStack {
                    Image("MenuBarIcon").resizable().scaledToFit().opacity(0)
                    Text("Send a message")
                }
                .padding()
                .background(.thinMaterial)
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
                    
                    if Defaults[.messagesSuccessfullySent] >= 5 {
                        requestReview()
                    }
                    
                    textField = ""
                }.keyboardShortcut(.defaultAction)
            }
            
            if showingSettings {
                VStack {
                    HStack {
                        Text("Settings").bold().foregroundColor(.gray)
                        Spacer()
                        
                    }
                    Divider()
                    FontSizeSliderView(text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
                        .onChange(of: Int(fontSize)) { newValue in
                            Defaults[.fontSize] = newValue
                            print("Updated font size in UserDefaults")
                        }
                    HStack {
                        TextField("Paste OpenAI API Key Here", text: $openAIKeyLocal)
                        
                        Button("Save") {
                            dataManager.push(key: .Butler_UserOpenAIKey, content: openAIKeyLocal.filter { !" \n\t\r".contains($0) })
                            openAIKeyLocal = ""
                        }
                    }.padding(.vertical)
                    
                    Button("Reset Settings") {
                        fontSize = 12
                    }
                    .padding(.bottom)
                }.padding().background(.thinMaterial).cornerRadius(20)
                
            }
        }
        .padding()
        
        
    }
}

struct FontSizeSliderView: View {
    var text: String
    var startValue: CGFloat
    var endValue: CGFloat
    @Binding var value: CGFloat
    var body: some View {
        VStack {
            HStack {
                Text(text).foregroundColor(.gray)
                
                Spacer()
            }
            
            SteppingSliderView(min: startValue, max: endValue, value: $value, step: 3)
        }
    }
}






struct EmailForHelpText: View {
    var body: some View {
        Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline)
    }
}
