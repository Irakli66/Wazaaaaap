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
    
    init(profile: ProfileModel = ProfileModel(
        fullName: "John Doe",
        username: "@jondexa",
        selectedLanguage: .english
    )) {
        self.profile = profile
    }
    
    // MARK: - Intent(s)
    func updateFullName(_ newName: String) {
        profile = ProfileModel(
            fullName: newName,
            username: profile.username,
            selectedLanguage: profile.selectedLanguage
        )
    }
    
    func updateUsername(_ newUsername: String) {
        profile = ProfileModel(
            fullName: profile.fullName,
            username: newUsername,
            selectedLanguage: profile.selectedLanguage
        )
    }
    
    func updateLanguage(_ language: ProfileModel.Language) {
        profile = ProfileModel(
            fullName: profile.fullName,
            username: profile.username,
            selectedLanguage: language
        )
    }
    
    func saveProfile() {
        isLoading = true
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
            // Handle success
        }
    }
    
    func logOut() {
        // Handle logout logic
    }
}
