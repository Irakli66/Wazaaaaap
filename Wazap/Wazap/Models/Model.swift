//
//  Model.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    var id: String
    var username: String
    var profilePictureURL: String
    var text: String
}
