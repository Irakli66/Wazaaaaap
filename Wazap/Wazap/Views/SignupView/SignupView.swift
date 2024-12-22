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
    @StateObject private var viewModel = SignupViewModel()
    @State private var errors: [ValidationError] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                navigationBar
                VStack(spacing: 10) {
                    InputView(text: $fullName,
                              title: "Full Name",
                              placeholder: "Your full name")
                        .autocapitalization(.none)
                    if let error = errors.first(where: { $0 == .fullName || $0 == .fullNameEmpty }) {
                        Text(error.errorDescription ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                    
                    InputView(text: $userName,
                              title: "Username",
                              placeholder: "Your username")
                        .autocapitalization(.none)
                    if let error = errors.first(where: { $0 == .username || $0 == .usernameEmpty }) {
                        Text(error.errorDescription ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }

                    InputView(text: $email,
                              title: "Email",
                              placeholder: "Your email address")
                        .autocapitalization(.none)
                    if let error = errors.first(where: { $0 == .email || $0 == .emailEmpty }) {
                        Text(error.errorDescription ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }

                    InputView(text: $password,
                              title: "Enter Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                        .padding(.top, 7)
                        .autocapitalization(.none)
                    if let error = errors.first(where: { $0 == .password || $0 == .passwordEmpty }) {
                        Text(error.errorDescription ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }

                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Enter your Password",
                              isSecureField: true)
                        .padding(.top, 7)
                        .autocapitalization(.none)
                    if let error = errors.first(where: { $0 == .confirmPassword || $0 == .confirmPasswordEmpty }) {
                        Text(error.errorDescription ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer().frame(height: 20)

                Button {
                    errors = viewModel.validateFields(fullName: fullName,
                                                      userName: userName,
                                                      email: email,
                                                      password: password,
                                                      confirmPassword: confirmPassword)
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
            }
            .padding(.bottom, 20)
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
    
    private func errorMessage(for error: ValidationError) -> String? {
        errors.first { $0 == error }?.errorDescription
    }
}

#Preview {
    SignupView()
}
