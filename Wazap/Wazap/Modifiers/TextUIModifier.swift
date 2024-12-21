//
//  TextUIModifier.swift
//  Wazap
//
//  Created by Apple on 21.12.24.
//


import SwiftUI

struct TextUIModifier: ViewModifier {
    let textColor: Color?
    let textSize: CGFloat?
    let font: String?
    
    init(textColor: Color? = nil, textSize: CGFloat? = nil, font: String? = nil) {
        self.textColor = textColor
        self.textSize = textSize
        self.font = font
    }

    func body(content: Content) -> some View {
        content
            .font(font != nil ? Font.custom(font!, size: textSize ?? 16) : .system(size: textSize ?? 16))  
            .foregroundColor(textColor ?? .black)
    }
}

extension View {
    func makeTextStyle(color: Color? = nil, size: CGFloat? = nil, font: String? = nil) -> some View {
        self.modifier(TextUIModifier(textColor: color, textSize: size, font: font))
    }
}
