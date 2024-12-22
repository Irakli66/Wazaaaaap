//
//  ChatModel.swift
//  Wazap
//
//  Created by Beka on 22.12.24.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    var id: String
    var username: String
    var profilePictureURL: String
    var text: String
    let userID: Int
}
