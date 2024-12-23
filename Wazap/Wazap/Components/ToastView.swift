//
//  ToastView.swift
//  Wazap
//
//  Created by Apple on 23.12.24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let bgColor: Color
    
    init(message: String, bgColor: Color = .green) {
        self.message = message
        self.bgColor = bgColor
    }

        var body: some View {
            Text(message)
                .padding()
                .background(bgColor.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
