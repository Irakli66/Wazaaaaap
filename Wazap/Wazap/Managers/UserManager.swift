//
//  UserManager.swift
//  Wazap
//
//  Created by irakli kharshiladze on 22.12.24.
//
import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func saveUserToFirestore(uid: String, email: String, fullname: String, username: String) async throws
}

final class UserManager: UserManagerProtocol {
    private let db = Firestore.firestore()
    
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
}
