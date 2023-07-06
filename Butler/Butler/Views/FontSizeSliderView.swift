//
//  FontSizeSliderView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/22/23.
//

import SwiftUI

struct FontSizeSliderView: View {
    public var padding = false
    var step: CGFloat
    var text: String
    var startValue: CGFloat
    var endValue: CGFloat
    @Binding var value: Double
    var body: some View {
        if !padding {
            VStack {
                HStack {
                    Text(text)
                    
                    Spacer()
                }
                
                SteppingSliderView(min: startValue, max: endValue, value: $value, step: step)
            }
        } else {
            VStack {
                HStack {
                    Text(text)
                    
                    Spacer()
                }
                
                SteppingSliderView(min: startValue, max: endValue, value: $value, step: step)
            }.padding()
        }
    }
}
