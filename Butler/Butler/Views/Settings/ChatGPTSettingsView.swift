//
//  ChatGPTSettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI

struct ChatGPTSettingsView: View {
    @AppStorage(AppStorageNames.chatGPTModel.name) var model = ChatGPTModels.gpt3.name
    @AppStorage(AppStorageNames.chatGPTTemperature.name) var creativity: Double = 1
    
    @State var APIKeyLocal = ""
    @State var modelLocal = ChatGPTModels.gpt3
    @State var secureField = true
    let keychainManager = KeychainManager()
    
    var body: some View {
        VStack {
            Picker("ChatGPT Version", selection: $modelLocal) {
                ForEach(ChatGPTModels.allCases, id: \.self) {
                    Text($0.name)
                }
            }
            
            FontSizeSliderView(step: 0.1, text: "Creativity", startValue: 0, endValue: 2, value: $creativity)
            
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
                    SecureField("Paste OpenAI API Key Here", text: $APIKeyLocal)
                        .autocorrectionDisabled(true)
                } else {
                    TextField("Paste OpenAI API Key Here", text: $APIKeyLocal)
                        .autocorrectionDisabled(true)
                }
                
                Button("Save") {
                    keychainManager.push(key: .Butler_UserOpenAIKey, content: APIKeyLocal.filter { !" \n\t\r".contains($0) })
                    APIKeyLocal = ""
                }
            }.padding(.vertical)
        }
        .padding()
        .frame(width: 400, height: 150)
        .onChange(of: modelLocal) { newValue in
            model = newValue.name
        }
        .onAppear {
            if model == ChatGPTModels.gpt3.name {
                modelLocal = .gpt3
            } else if model == ChatGPTModels.gpt4.name {
                modelLocal = .gpt4
            }
        }
    }
}

struct ChatGPTSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTSettingsView()
    }
}
