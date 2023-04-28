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

#if os(iOS)
import GoogleMobileAds
#endif

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
                
#if os(macOS)
                Button("Quit") { exit(0) }
#endif
            }
            
            //            Divider()
            
            if connector.messageLog != [["role": "system", "content": "You're a friendly, helpful assistant"]] {
                //                Divider()
                
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
                TextField("Type here", text: $textField)
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
            
            if !showingSettings {
                EmailForHelpText()
            }
            
            if showingSettings {
                VStack {
                    HStack {
                        Text("Settings").bold().foregroundColor(.gray)
                        Spacer()
                        
                    }
                    Divider()
                    SettingsSliderView(text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
                        .onChange(of: Int(fontSize)) { newValue in
                            Defaults[.fontSize] = newValue
                            print("Updated font size in UserDefaults")
                        }
                    
                    
//                    Text("\(fontSize)")
//                    Picker("Select Window Size", selection: $selectedWindowSizeLocal) {
//                        Text("Small").tag(WindowSizeUserPreferenceLocal.small)
//                        Text("Medium").tag(WindowSizeUserPreferenceLocal.medium)
//                        Text("Large (Might be too big for small screens)").tag(WindowSizeUserPreferenceLocal.large)
//                    }.onChange(of: selectedWindowSizeLocal) { newValue in
//                        var newValueString: String {
//                            switch newValue {
//                            case .small:
//                                return "small"
//                            case .medium:
//                                return "medium"
//                            case .large:
//                                return "large"
//                            }
//                        }
//
//
//                        Defaults[.windowSize] = newValueString
//                        windowSize = newValueString
//                    }
                    
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
                
                
               
                
                EmailForHelpText()
            }
            
#if os(iOS)
            SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-5488373209303539/4357719195")
#endif
        }
        .padding()
        
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(showingSettings: true, windowSize: "medium")
//            .previewDisplayName("Medium Menu Bar Preview - Showing Settings")
//            .environmentObject(OpenAIConnector(messageLog: [
//                ["role": "user", "content": "Hey, how's it going?"],
//                ["role": "assistant", "content": "Good, how bout you?"],
//                
//                
//            ])).frame(width: 600, height: 750)
//        
//        ContentView()
//            .previewDisplayName("Medium Menu Bar Preview")
//            .environmentObject(OpenAIConnector(messageLog: [
//                ["role": "user", "content": "Hey, how's it going?"],
//                ["role": "assistant", "content": "Good, how bout you?"],
//                
//                
//            ])).frame(width: 600, height: 750)
//        
//        ContentView()
//            .previewDisplayName("Medium Menu Bar Preview - No Messages")
//            .environmentObject(OpenAIConnector()).frame(width: 600, height: 750)
//    }
//}

struct SettingsSliderView: View {
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

struct SteppingSliderView: View {
    var min: CGFloat
    var max: CGFloat
    @Binding var value: CGFloat
    
    var step: CGFloat
    
    var body: some View {
        VStack {
            Slider(
                value: $value,
                in: min...max,
                step: step,
                minimumValueLabel: Text(formated(value: min)),
                maximumValueLabel: Text(formated(value: max)),
                label: { })
        }
    }
    
    func formated(value: CGFloat) -> String {
        return String(format: "%.0f", value)
    }
    
}


struct MessageView: View {
    @Binding var fontSize: CGFloat
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
                Markdown(message["content"] ?? "error")
                    .padding(.all, 15)
                    .markdownTextStyle(\.text) {
                        ForegroundColor(.white)
                        FontSize(fontSize)
                    }
                    .background(messageColor)
                    .textSelection(.enabled)
                
                //                Text(message["content"] ?? "error")
                //                    .padding(.all, 15)
                //                    .foregroundColor(Color.white)
                //                    .background(messageColor)
            }
            
            if message["role"] == "assistant" {
                Button("Copy") {
                    copyStringToClipboard(message["content"] ?? "error")
                }.font(.system(size: fontSize))
                Spacer()
            }
        }
    }
}


struct EmailForHelpText: View {
    var body: some View {
        Text("Email aditya.saravana@icloud.com for help.").bold().font(.subheadline)
    }
}
