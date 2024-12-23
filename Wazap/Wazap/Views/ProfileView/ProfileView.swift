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
    @State private var showToast = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                VStack(spacing: 0) {
                    navigationBar

                    ScrollView {
                        VStack {
                            profileImageSection
                            fullNameSection
                            usernameSection
                            languageSection
                            themeSwitch
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

            Text(viewModel.selectedLanguage == .english ? "Your Profile" : "შენი პროფილი")
                .font(.system(size: 20))

            Spacer()

            Button(viewModel.selectedLanguage == .english ? "Save" : "შენახვა") {
                Task {
                    let _ = await viewModel.saveProfile(fullName: fullName, username: username, profileImage: selectedImage)
                    await viewModel.getUserInfo()
                }
                withAnimation {
                    showToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(.customBlue)
        .frame(height: 22)
        .padding(.horizontal, 16)
        .frame(height: 52)
        .overlay {
            if showToast {
                ToastView(message: "Profile Updated")
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
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
            Text(viewModel.selectedLanguage == .english ? "Full name" : "სრული სახელი")
                .foregroundColor(.gray)
                .font(.system(size: 14))

            HStack {
                TextField(viewModel.selectedLanguage == .english ? "Full name" : "სრული სახელი", text: $fullName)
                Image("N-badge")
            }
            .padding()
            .background(.profileCustomField)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private var usernameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.selectedLanguage == .english ? "Username" : "ზედმეტსახელი")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top, 19)
            TextField(viewModel.selectedLanguage == .english ? "Username" : "ზედმეტსახელი", text: $username)
                .padding()
                .background(.profileCustomField)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }

    private var languageSection: some View {
        VStack {
            Text(viewModel.selectedLanguage == .english ? "Language" : "ენა")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top, 39)

            HStack(spacing: 50) {
                languageButton(
                    title: "ქართული",
                    isSelected: viewModel.selectedLanguage == .georgian,
                    action: { viewModel.updateLanguage(.georgian) }
                )

                languageButton(
                    title: "English",
                    isSelected: viewModel.selectedLanguage == .english,
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

    private var themeSwitch: some View {
        HStack(spacing: 16) {
            Text(viewModel.selectedLanguage == .english ? "Theme" : "ფერი")
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .medium, design: .rounded))

            Spacer()

            Toggle(isOn: $viewModel.isDarkTheme) {
                Text(viewModel.isDarkTheme ? viewModel.selectedLanguage == .english ? "Dark" : "მუქი" : viewModel.selectedLanguage == .english ? "Light" : "ღია")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
        .padding(.top, 25)
    }

    private var logoutButton: some View {
        Button(action: logOut) {
            Text(viewModel.selectedLanguage == .english ? "Log out" : "გამოსვლა")
                .foregroundColor(.white)
                .frame(width: 128, height: 40)
                .background(.customRed)
                .cornerRadius(10)
                .padding(.top, 100)
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
