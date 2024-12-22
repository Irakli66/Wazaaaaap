//
//  AuthenticationManager.swift
//  Wazap
//
//  Created by irakli kharshiladze on 22.12.24.
//
import Foundation
import FirebaseAuth

protocol AuthenticationManagerProtocol {
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    func getCurrentUser() -> AuthDataResultModel?
    func signOut() throws
}


final class AuthenticationManager: AuthenticationManagerProtocol {
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getCurrentUser() -> AuthDataResultModel? {
        guard let user = Auth.auth().currentUser else { return nil }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
