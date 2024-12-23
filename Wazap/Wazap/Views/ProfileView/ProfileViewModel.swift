//
//  ProfileViewModel.swift
//  Wazaaaaap
//
//  Created by Imac on 21.12.24.
//

import SwiftUI
import Combine

enum AppLanguage: String {
    case georgian = "ქართული"
    case english = "English"
}

class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: ProfileModel
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var user: UserModel?
    @AppStorage("selectedLanguage") var selectedLanguageRawValue: String = AppLanguage.english.rawValue
    @AppStorage("isDarkTheme") var isDarkTheme: Bool = false
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    
    var selectedLanguage: AppLanguage {
        get { AppLanguage(rawValue: selectedLanguageRawValue) ?? .english }
        set { selectedLanguageRawValue = newValue.rawValue }
    }
    
    init(profile: ProfileModel = ProfileModel(
        fullName: "John Doe",
        username: "@jondexa",
        selectedLanguage: .english
    ), authenticationManager: AuthenticationManagerProtocol = AuthenticationManager(), userManager: UserManagerProtocol = UserManager()) {
        self.profile = profile
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    func updateLanguage(_ language: AppLanguage) {
        selectedLanguage = language
        print("Language updated to: \(selectedLanguage)")
    }
    
    func saveTheme() {
        isDarkTheme.toggle()
        print("Theme updated: \(isDarkTheme ? "Dark" : "Light")")
    }
    
    func saveProfile(fullName: String, username: String, profileImage: UIImage?) async {
        guard let userId = authenticationManager.getCurrentUser()?.uid else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            
        }
        
        do {
            var profileImageUrl: String? = nil
            
            if let profileImage = profileImage {
                profileImageUrl = try await userManager.uploadProfileImage(image: profileImage, userId: userId)
            }
            
            try await userManager.updateUserFullnameAndUsername(uid: userId, fullname: fullName, username: username, imageUrl: profileImageUrl)
            
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
            
            print("Profile updated successfully!")
        } catch {
            print("Error updating profile: \(error.localizedDescription)")
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
