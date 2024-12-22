//
//  ProfileViewModel.swift
//  Wazaaaaap
//
//  Created by Imac on 21.12.24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: ProfileModel
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var user: UserModel?
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    
    init(profile: ProfileModel = ProfileModel(
        fullName: "John Doe",
        username: "@jondexa",
        selectedLanguage: .english
    ), authenticationManager: AuthenticationManagerProtocol = AuthenticationManager(), userManager: UserManagerProtocol = UserManager()) {
        self.profile = profile
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    // MARK: - Intent(s)
    
    func updateLanguage(_ language: ProfileModel.Language) {
        profile = ProfileModel(
            fullName: profile.fullName,
            username: profile.username,
            selectedLanguage: language
        )
    }
    
    func saveProfile(fullName: String, username: String) async {
        guard let userId = authenticationManager.getCurrentUser()?.uid else {
            return
        }
        
        DispatchQueue.main.async {
                self.isLoading = true
            }
        
        do {
            try await userManager.updateUserFullnameAndUsername(uid: userId, fullname: fullName, username: username)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error updating user data: \(error)")
            }
        }
    }
    
    func getUserInfo() async {
        guard let userId = authenticationManager.getCurrentUser()?.uid else {
            return
        }
        
        do {
            let user = try await userManager.getUser(by: userId)
            DispatchQueue.main.async {
                self.user = user
            }
        } catch {
            DispatchQueue.main.async {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func getCurrentUser() -> AuthDataResultModel? {
        return authenticationManager.getCurrentUser()
    }
    func signOut() throws  {
        try authenticationManager.signOut()
    }
}
