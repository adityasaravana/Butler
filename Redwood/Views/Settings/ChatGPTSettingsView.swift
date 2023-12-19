//
//  ChatGPTSettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI
import Defaults
import OpenAIKit

struct ChatGPTSettingsView: View {
    @Default(.chatGPTModel) var model
    @Default(.userAPIKey) var apiKey
    @Default(.userChatGPTPrompt) var prompt
    
    @State var secureField = true
    
    var body: some View {
        List {
            HStack {
                Button {
                    secureField.toggle()
                } label: {
                    if secureField {
                        Image(systemName: "eye.slash")
                    } else {
                        Image(systemName: "eye")
                    }
                }
                
                if secureField {
                    SecureField("Paste OpenAI API Key Here", text: $apiKey)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)
                } else {
                    TextField("Paste OpenAI API Key Here", text: $apiKey)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            HStack {
                TextField("Custom Instructions", text: $prompt)
                    .textFieldStyle(.roundedBorder)
                Button("Apply To New Chats") {}
            }
            
            Picker("ChatGPT Version", selection: $model) {
                ForEach(ChatGPTModels.allCases, id: \.self) {
                    Text($0.name)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    ChatGPTSettingsView()
}
