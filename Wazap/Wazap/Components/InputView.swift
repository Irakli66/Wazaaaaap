//
//  InputView.swift
//  Wazap
//
//  Created by Apple on 21.12.24.
//


import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    @State var isShow: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                
                .font(.system(size: 12))
            
            VStack {
                if isSecureField {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 10)
                        
                        if isShow {
                            TextField(placeholder, text: $text)
                                .foregroundStyle(.customPageTitle)
                        } else {
                            SecureField(placeholder, text: $text)
                                .foregroundStyle(.customPageTitle)
                        }
                        
                        Button {
                            isShow.toggle()
                        } label: {
                            Image(systemName: isShow ? "eye.fill" : "eye.slash")
                        }
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 15))
                        .foregroundStyle(.customPageTitle)
                }
            }
            .padding()
            .foregroundStyle(.black)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            }
        }
        .foregroundStyle(.customText)
    }
}

#Preview {
    InputView(text: .constant("eewsds"),
              title: "სახელი",
              placeholder: "ტექსტფილდი")
              //isSecureField: true)
}
