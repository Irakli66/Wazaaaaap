//
//  LaunchScreenView.swift
//  Wazap
//
//  Created by beqa on 23.12.24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    LaunchScreen()
    
}
