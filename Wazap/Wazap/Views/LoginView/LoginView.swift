//
//  LoginView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    //@EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // image
                Image("monkey")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                //form field
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
                .padding(.top, 12)
                
                //sing in button
                
                NavigationLink {
                    SignupView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("New To Wazaaaaap?")
                            .font(.system(size: 12))
                        Spacer()
                        Text("Sing Up")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                    }
                }
                .foregroundStyle(.customText)
                .padding()
                
                Spacer()
                
                //sing in buttons
                
                VStack(spacing: 10) {
                    Button {
                        Task {
                            //try await viewModel.sinIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "g.circle")
                            Text("Continue with Goole")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width - 40 , height: 64)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.5), radius: 1)
                    }
                    
                    
                    
                    
                    Button {
                        Task {
                            //try await viewModel.sinIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("Log In")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 40 , height: 64)
                    }
                    //.disabled(!formIsValid)
                    //.opacity(formIsValid ? 1.0 : 0.5)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 40 , height: 64)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)

                }
                
                
                .padding(.top, 24)
            }
        }
        .background(.customBackground)
        .padding()
        
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

#Preview {
    LoginView()
}
