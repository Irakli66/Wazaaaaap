//
//  SignupView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var fullName = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
            VStack(spacing: 0) {
                navigationBar
                    .padding(.bottom, 20)

                VStack(spacing: 10) {
                    InputView(text: $fullName,
                              title: "Full Name",
                              placeholder: "Your full name")
                        .autocapitalization(.none)
                    
                    InputView(text: $userName,
                              title: "Username",
                              placeholder: "Your username")
                        .autocapitalization(.none)
                    
                    InputView(text: $email,
                              title: "Email",
                              placeholder: "Your email address")
                        .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Enter Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                    .padding(.top, 7)
                    
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                    .padding(.top, 7)
                    
                    if !passwordsMatch {
                        Text("Passwords don't match")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer().frame(height: 153)
                
                Button {
                    Task {
                        if passwordsMatch {
                            // signup
                        }
                    }
                } label: {
                    HStack {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 64)
                }
                .background(Color("customBlue"))
                .cornerRadius(10)
                .padding(.horizontal, 20)

                Spacer(minLength: 20)
            }
    }

    private var navigationBar: some View {
        HStack {
            backButton
            Spacer()
            Text("Sign up")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .navigationBarHidden(true) 
    }

    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundColor(Color("customBlue"))
        }
    }
    
    private var passwordsMatch: Bool {
        password == confirmPassword || confirmPassword.isEmpty
    }
}

#Preview {
    SignupView()
}
