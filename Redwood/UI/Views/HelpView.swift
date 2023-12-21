//
//  HelpView.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/21/23.
//

import SwiftUI
import SharedCode

struct HelpView: View {
    var body: some View {
        Text("Email aditya.saravana@icloud.com for help.")
            .bold()
            .font(.subheadline)
            .padding()
            .onTapGesture {
                BetterSupportEmails().openEmailView()
            }
    }
}

#Preview {
    HelpView()
}
