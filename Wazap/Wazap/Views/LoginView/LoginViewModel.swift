//
//  LoginViewModel.swift
//  Wazap
//
//  Created by irakli kharshiladze on 22.12.24.
//
import Foundation

final class LoginViewModel: ObservableObject {
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    
    init(authenticationManager: AuthenticationManagerProtocol = AuthenticationManager(), userManager: UserManagerProtocol = UserManager()) {
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    func signIn(email: String, password: String) async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return false
        }
        do {
            let _ = try await authenticationManager.loginUser(email: email, password: password)
            return true
        } catch {
            print("Error signing in: \(error)")
            return false
        }
    }
    
    func checkUserStatus() -> Bool {
        return authenticationManager.getCurrentUser() != nil
    }
}
