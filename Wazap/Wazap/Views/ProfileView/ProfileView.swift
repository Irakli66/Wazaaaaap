//
//  ProfileView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import Foundation
import SwiftUI


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isLoggedIn: Bool = true
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
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
                //                .onAppear {
                //                    Task {
                //                        await viewModel.getUser
                //                    }
                //                }
                .background(Color.gray.opacity(0.1))
                .overlay(loadingOverlay)
            } else {
                LoginView()
            }
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image("Arrow")
                    .foregroundColor(.blue)
                    .frame(width: 20,height: 28)
            }
            
            Spacer()
            
            Text("Your profile")
                .font(.system(size: 20))
            
            Spacer()
            
            Button("Save") {
                viewModel.saveProfile()
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(Color(hex: "#5159F6"))
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
                TextField("Full name", text: Binding(
                    get: { viewModel.profile.fullName },
                    set: { viewModel.updateFullName($0) }
                ))
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
            TextField("Username", text: Binding(
                get: { viewModel.profile.username },
                set: { viewModel.updateUsername($0) }
            ))
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
                .background(isSelected ? Color(hex: "#5159F6") : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
        }
    }
    
    private var logoutButton: some View {
        Button(action: logOut) {
            Text("Log out")
                .foregroundColor(.white)
                .frame(width: 128, height: 40)
                .background(Color.red)
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


extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
//
