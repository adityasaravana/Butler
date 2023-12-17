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
    
    func formatted(value: CGFloat) -> String {
        return String(format: "%.0f", value)
    }
    
    var body: some View {
        Slider(
            value: $value,
            in: startValue...endValue,
            step: step,
            minimumValueLabel: Text(formatted(value: startValue)),
            maximumValueLabel: Text(formatted(value: endValue)),
            label: { Text(text) }).if(padding) { view in view.padding() }
    }
}
