//
//  UserManager.swift
//  Wazap
//
//  Created by irakli kharshiladze on 22.12.24.
//
import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol UserManagerProtocol {
    func uploadProfileImage(image: UIImage, userId: String) async throws -> String
    func saveUserToFirestore(uid: String, email: String, fullname: String, username: String) async throws
    func getUser(by uid: String) async throws -> UserModel
    func updateUserFullnameAndUsername(uid: String, fullname: String, username: String, imageUrl: String?) async throws
}

final class UserManager: UserManagerProtocol {
    private let db = Firestore.firestore()
    
    func uploadProfileImage(image: UIImage, userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "Image Conversion Error", code: 0, userInfo: nil)
        }
        let storageRef = Storage.storage().reference().child("profile_pictures/\(userId).jpg")
        
        let _ = try await storageRef.putDataAsync(imageData)
        
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    
    func saveUserToFirestore(uid: String, email: String, fullname: String, username: String) async throws {
        let userData: [String: Any] = [
            "uid": uid,
            "email": email,
            "fullName": fullname,
            "username": username,
            "createdAt": Timestamp(date: Date()),
            "photoUrl": ""
        ]
        try await db.collection("users").document(uid).setData(userData)
    }
    
    func updateUserFullnameAndUsername(uid: String, fullname: String, username: String, imageUrl: String?) async throws {
        var dataToUpdate: [String: Any] = [
            "fullName": fullname,
            "username": username,
        ]
        
        if let imageUrl = imageUrl {
            dataToUpdate["photoUrl"] = imageUrl
        }
        
        try await db.collection("users").document(uid).updateData(dataToUpdate)
    }
    
    func getUser(by uid: String) async throws -> UserModel {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "UserManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        guard
            let uid = data["uid"] as? String,
            let email = data["email"] as? String,
            let fullName = data["fullName"] as? String,
            let username = data["username"] as? String,
            let timestamp = data["createdAt"] as? Timestamp,
            let photoUrl = data["photoUrl"] as? String else {
            throw NSError(domain: "UserManager", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }
        
        let createdAt = timestamp.dateValue()
        return UserModel(id: uid, uid: uid, email: email, fullName: fullName, username: username, createdAt: createdAt, photoUrl: photoUrl)
    }
}
