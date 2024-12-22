//
//  AuthDataResultModel.swift
//  Wazap
//
//  Created by irakli kharshiladze on 22.12.24.
//
import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}
