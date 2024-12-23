//
//  LoginView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var userStatus: Bool = false
    @State private var showToast = false
    @State private var showErrorToast = false
    
    var formIsValid: Bool {
        return !email.isEmpty
        && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            if userStatus {
                ChatView()
            } else {
                VStack {
                    Image("Wazaaaaap")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 233)
                        .overlay {
                            if showToast && !userStatus {
                                ToastView(message: "logged in successfully")
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                    .zIndex(1)
                            } else if showErrorToast {
                                ToastView(message: "email or pasword is wrong", bgColor: Color.red)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                    .zIndex(1)
                            }
                        }
                    Spacer()
                    VStack(spacing: 24) {
                        InputView(text: $email,
                                  title: "Email",
                                  placeholder: "Your email address")
                        .autocapitalization(.none)
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your Password",
                                  isSecureField: true)
                    }
                    .padding(.horizontal)
                    NavigationLink {
                        SignupView()
                    } label: {
                        HStack(spacing: 3) {
                            Text("New To Wazaaaaap?")
                                .font(.system(size: 12))
                            Spacer()
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .font(.system(size: 18))
                        }
                    }
                    .foregroundStyle(.customText)
                    .padding()
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Button {
                            Task {
                                do {
                                    try await viewModel.signInGoogle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        userStatus = true
                                    }
                                    withAnimation {
                                        showToast = true
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            HStack {
                                Image("Google")
                                Text("Continue with Google")
                                    .fontWeight(.semibold)
                                    .makeTextStyle(color: .gray, size: 20)
                            }
                            .makeButtonStyle(tintColor: Color.textBg, backgroundColor: .white, width: UIScreen.main.bounds.width - 40, height: 64)
                            .shadow(color: .gray.opacity(0.5), radius: 2)
                        }
                        Button {
                            Task {
                                let response = await viewModel.signIn(email: email, password: password)
                                if response {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        userStatus = true
                                    }
                                    withAnimation {
                                        showToast = true
                                    }
                                } else {
                                    showErrorToast = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showErrorToast = false
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                            }
                        }
                        .makeButtonStyle(tintColor: Color.textBg, backgroundColor: Color.customBlue, width: UIScreen.main.bounds.width - 40, height: 64)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    .padding(.top, 24)
                }
                .padding()
                .background(.customBackground)
                .onAppear {
                    Task {
                        userStatus = viewModel.checkUserStatus()
                    }
                }
            }
        }
    }
}




//#Preview {
//    LoginView()
//}
