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
            
            Divider()
            
            Picker("ChatGPT Version", selection: $model) {
                ForEach(ChatGPTModels.allCases, id: \.self) {
                    Text($0.name)
                }
            }.pickerStyle(.segmented)
            
            
            
        }
    }
}

struct ChatGPTSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTSettingsView()
    }
}
