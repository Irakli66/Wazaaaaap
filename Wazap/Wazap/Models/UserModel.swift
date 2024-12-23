//
//  UserModel.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import Foundation
import FirebaseFirestore

struct UserModel: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    let fullName: String
    let username: String
    let createdAt: Date
    let photoUrl: String
}
