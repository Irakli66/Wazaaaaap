//
//  ViewModel.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import FirebaseFirestore
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""

    private let db = Firestore.firestore()
    private let chatRoomID = "chatRoomID1"

    init() {
        fetchMessages()
    }

    func fetchMessages() {
        db.collection("chats").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.messages = documents.compactMap { doc in
                    let data = doc.data()
                    return ChatMessage(
                        id: doc.documentID,
                        username: data["username"] as? String ?? "Anonymous",
                        profilePictureURL: data["profilePictureURL"] as? String ?? "",
                        text: data["text"] as? String ?? ""
                    )
                }
            }
    }

    func sendMessage() {
        guard !messageText.isEmpty else { return }

        let messageData: [String: Any] = [
            "username": "Guest",
            "profilePictureURL": "https://example.com/default-profile.jpg",
            "text": messageText,
            "timestamp": FieldValue.serverTimestamp() 
        ]

        db.collection("chats").document(chatRoomID).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    self.messageText = ""
                }
            }
    }
}
