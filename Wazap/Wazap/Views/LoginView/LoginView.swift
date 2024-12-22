//
//  LoginView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var userStatus: Bool = false
    
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
                                    userStatus = true
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
                                    userStatus = true // Update status if login succeeds
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


//MARK: პაროლის შეზღუდვა
//extension LoginView: AuthenticationFormProtocol {
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count > 5
//    }
//}

//#Preview {
//    LoginView()
//}
