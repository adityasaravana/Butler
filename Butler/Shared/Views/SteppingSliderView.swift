//
//  SteppingSliderView.swift
//  Butler
//
//  Created by Aditya Saravana on 4/30/23.
//

import SwiftUI

struct SteppingSliderView: View {
    var min: CGFloat
    var max: CGFloat
    @Binding var value: CGFloat
    
    var step: CGFloat
    
    var body: some View {
        VStack {
            Slider(
                value: $value,
                in: min...max,
                step: step,
                minimumValueLabel: Text(formated(value: min)),
                maximumValueLabel: Text(formated(value: max)),
                label: { })
        }
    }
    
    func formated(value: CGFloat) -> String {
        return String(format: "%.0f", value)
    }
}
