//
//  ProfileView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import Foundation
import SwiftUI
import Kingfisher


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isLoggedIn: Bool = true
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var fullName: String = ""
    @State private var username: String = ""
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                VStack(spacing: 0) {
                    navigationBar
                    
                    ScrollView {
                        VStack() {
                            profileImageSection
                            fullNameSection
                            usernameSection
                            languageSection
                            Spacer()
                            logoutButton
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.getUserInfo()
                        fullName = viewModel.user?.fullName ?? ""
                        username = viewModel.user?.username ?? ""
                    }
                }
                .background(.customBackground)
                .overlay(loadingOverlay)
            } else {
                LoginView()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("Your profile")
                .font(.system(size: 20))
            
            Spacer()
            
            Button("Save") {
                print(selectedImage ?? "")
                Task {
                    let _ = await viewModel.saveProfile(fullName: fullName, username: username, profileImage: selectedImage)
                    await viewModel.getUserInfo()
                }
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.customBlue)
            .frame(width: 38,height: 22)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        
        
    }
    
    private var profileImageSection: some View {
        Button(action: {
            showImagePicker = true
        }) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    )
            } else if let photoUrl = viewModel.user?.photoUrl, let url = URL(string: photoUrl) {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    )
            } else {
                Image("Avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    )
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .padding(.top, 16)
    }
    
    private var fullNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full name")
                .foregroundColor(.gray)
                .font(.system(size: 14))
            
            HStack {
                TextField("Full name", text: $fullName)
                Image("N-badge")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        
        
    }
    
    private var usernameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top, 19)
            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private var languageSection: some View {
        VStack() {
            Text("Language")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top, 39)
            
            HStack(spacing: 50) {
                languageButton(
                    title: ProfileModel.Language.georgian.rawValue,
                    isSelected: viewModel.profile.selectedLanguage == .georgian,
                    action: { viewModel.updateLanguage(.georgian) }
                )
                
                languageButton(
                    title: ProfileModel.Language.english.rawValue,
                    isSelected: viewModel.profile.selectedLanguage == .english,
                    action: { viewModel.updateLanguage(.english) }
                )
            }
            .padding(.horizontal, 40)
        }
    }
    
    private func languageButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? .customBlue : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
        }
    }
    
    
    private var logoutButton: some View {
        Button(action: logOut) {
            Text("Log out")
                .foregroundColor(.white)
                .frame(width: 128, height: 40)
                .background(.customRed)
                .cornerRadius(10)
                .padding(.top, 192)
                .font(.system(size: 20, weight: .bold))
        }
    }
    
    private func logOut() {
        do {
            try viewModel.signOut()
            isLoggedIn = false
        } catch {
            print("error \(error)")
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    )
            }
        }
    }
    
}

//#Preview {
//    ProfileView()
//}
