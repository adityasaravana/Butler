//
//  ChatGPTSettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI
import Defaults

struct ChatGPTSettingsView: View {
    @Default(.chatGPTModel) var model
    @Default(.chatGPTTemperature) var creativity
    @Default(.showLimitedAccessWarning) var showLimitedAccessWarning
    
    @State var showLimitedAccessWarningAlert = false
    @State var APIKeyLocal = ""
    @State var modelLocal = ChatGPTModels.gpt3
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
                    SecureField("Paste OpenAI API Key Here", text: $APIKeyLocal)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)
                } else {
                    TextField("Paste OpenAI API Key Here", text: $APIKeyLocal)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button("Save") {
                    Defaults[.userAPIKey] = APIKeyLocal.filter { !" \n\t\r".contains($0) }
                    APIKeyLocal = ""
                }
            }
            
            Divider()
            
            Picker("ChatGPT Version", selection: $modelLocal) {
                ForEach(ChatGPTModels.allCases, id: \.self) {
                    Text($0.name)
                }
            }.pickerStyle(.segmented)
            
            FontSizeSliderView(step: 0.1, text: "Creativity", startValue: 0, endValue: 2, value: $creativity)
            
            
        }
        .alert("\(modelLocal.name) isn't publicly available. You need to apply for access on OpenAI's site to use this model. Are you sure you have access?", isPresented: $showLimitedAccessWarningAlert) {
            
            Button("Yes, I have access.", role: .cancel) {}
            Button("Yes, I have access, and stop showing me this message.", role: .destructive) {
                showLimitedAccessWarning = false
            }
        }
        .onChange(of: modelLocal) { newValue in
            model = newValue
            if model == .gpt4 && showLimitedAccessWarning {
                showLimitedAccessWarningAlert = true
            }
        }
        .onAppear {
            if model == ChatGPTModels.gpt3 {
                modelLocal = .gpt3
            } else if model == ChatGPTModels.gpt4 {
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
