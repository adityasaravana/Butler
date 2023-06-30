//
//  FontSizeSliderView.swift
//  Butler
//
//  Created by Aditya Saravana on 6/22/23.
//

import SwiftUI

struct FontSizeSliderView: View {
    var step: CGFloat
    var text: String
    var startValue: CGFloat
    var endValue: CGFloat
    @Binding var value: Double
    var body: some View {
        VStack {
            HStack {
                Text(text)
                
                Spacer()
            }
            
            SteppingSliderView(min: startValue, max: endValue, value: $value, step: step)
        }
    }
}
