//
//  SettingsView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/22/23.
//

import SwiftUI
import Defaults
import KeyboardShortcuts

struct SettingsView: View {
    @Binding var fontSize: CGFloat
    @State var openAIKeyLocal = ""
    let dataManager = DataManager()
    var body: some View {
        VStack {
            HStack {
                Text("Settings").bold().foregroundColor(.gray)
                Spacer()
                
            }
            Divider()
            KeyboardShortcuts.Recorder("Reopen Butler", name: .openButler)
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
        }.padding().background(.thickMaterial).cornerRadius(20)
    }
}

