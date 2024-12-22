//
//  ChatModel.swift
//  Wazap
//
//  Created by Beka on 22.12.24.
//

import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    var id: String
    var username: String
    var profilePictureURL: String
    var text: String
    let userID: String
    var timestamp: String
    var emoji: [Emoji]
    
    var emojiArray: [Emoji] {
        var emojiLoop: [Emoji] = []
        
        for i in emoji {
            if let index = emojiLoop.firstIndex(where: { $0.name == i.name }) {
                emojiLoop[index].count += 1
            } else {
                emojiLoop.append(Emoji(name: i.name, count: 1))
            }
        }
        return emojiLoop
    }
 
}
 
struct Emoji: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var count: Int
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "name": name,
                "count": count
            ]
        }
    }
