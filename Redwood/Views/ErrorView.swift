//
//  ErrorView.swift
//  Butler
//
//  Created by Aditya Saravana on 7/2/23.
//

import SwiftUI

struct ErrorView: View {
    var debugDescription: String
    var body: some View {
        
        
        
        VStack(alignment: .center) {
            Image("vader")
                .resizable()
                .frame(width: 111, height: 200)
                .shadow(color: .red, radius: 100)
            
            Text("Fatal Error")
                .bold()
                .font(.title)
                .padding(.top)
                .foregroundColor(.red)
                .padding(.bottom)
            Text("You underestimate the power of the Dark Side.")
                .font(.title3)
                .bold()
            
            Text("Email aditya.saravana@icloud.com")
            
            Spacer()
            
            Text("⚠️ ERROR DESCRIPTION: ⚠️")
                .bold()
            
            Text(debugDescription)
            
        }
        .padding(30)
        .background(Color.black.opacity(0.9))
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(debugDescription: "DEBUGERRORCONTENT")
    }
}
