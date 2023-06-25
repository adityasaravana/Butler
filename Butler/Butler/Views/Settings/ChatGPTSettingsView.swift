//
//  ChatGPTSettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI

struct ChatGPTSettingsView: View {
    @AppStorage(AppStorageNames.chatGPTTemperature.name) var creativity: Double = 1
    
    @State var openAIKeyLocal = ""
    let keychainManager = KeychainManager()
    
    var body: some View {
        VStack {
            FontSizeSliderView(step: 0.1, text: "Creativity", startValue: 0, endValue: 2, value: $creativity)
            
            HStack {
                TextField("Paste OpenAI API Key Here", text: $openAIKeyLocal)

                Button("Save") {
                    keychainManager.push(key: .Butler_UserOpenAIKey, content: openAIKeyLocal.filter { !" \n\t\r".contains($0) })
                    openAIKeyLocal = ""
                }
            }.padding(.vertical)
        }
        .padding()
        .frame(width: 400, height: 150)
    }
}

struct ChatGPTSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTSettingsView()
    }
}
