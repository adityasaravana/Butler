//
//  GeneralTabView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/24/23.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("fontSize") var fontSize: Double = 12.0
    @State var openAIKeyLocal = ""
    let keychainManager = KeychainManager()
    var body: some View {
        VStack {
            FontSizeSliderView(text: "Message Font Size", startValue: 9, endValue: 30, value: $fontSize)
            HStack {
                TextField("Paste OpenAI API Key Here", text: $openAIKeyLocal)

                Button("Save") {
                    keychainManager.push(key: .Butler_UserOpenAIKey, content: openAIKeyLocal.filter { !" \n\t\r".contains($0) })
                    openAIKeyLocal = ""
                }
            }.padding(.vertical)
        }.padding()
    }
}

private struct Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}

