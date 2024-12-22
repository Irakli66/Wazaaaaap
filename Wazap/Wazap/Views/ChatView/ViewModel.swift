//
//  ViewModel.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import FirebaseFirestore
import SwiftUI
import AVFoundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    var emojiArray = ["like", "love", "beer", "cry", "devil"]
    var audioPlayer: AVAudioPlayer?
    
    private let db = Firestore.firestore()
    private let chatRoomID = "chatRoomID1"
    private var lastFetchedMessage: QueryDocumentSnapshot?
    private var firstFetchedMessage: QueryDocumentSnapshot?
    private let limit = 50

    init() {
        fetchInitialMessages()
    }

    func fetchInitialMessages() {
        db.collection("chats").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: false)
            .limit(to: limit)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching initial messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.messages = documents.compactMap { doc in
                    self.createMessage(from: doc)
                }
                self.lastFetchedMessage = documents.last
                self.firstFetchedMessage = documents.first
            }
    }

    func fetchOlderMessages() {
        guard let firstFetchedMessage = firstFetchedMessage else { return }

        db.collection("chats").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: false)
            .end(beforeDocument: firstFetchedMessage)
            .limit(toLast: limit)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching older messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let olderMessages = documents.compactMap { doc in
                    self.createMessage(from: doc)
                }
                self.messages.insert(contentsOf: olderMessages, at: 0)
                self.firstFetchedMessage = documents.first
            }
    }

    func fetchNewerMessages() {
        guard let lastFetchedMessage = lastFetchedMessage else { return }

        db.collection("chats").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: false)
            .start(afterDocument: lastFetchedMessage)
            .limit(to: limit)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching newer messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let newerMessages = documents.compactMap { doc in
                    self.createMessage(from: doc)
                }
                self.messages.append(contentsOf: newerMessages)
                self.lastFetchedMessage = documents.last
            }
    }

    private func createMessage(from doc: QueryDocumentSnapshot) -> ChatMessage {
        let data = doc.data()
        return ChatMessage(
            id: doc.documentID,
            username: data["username"] as? String ?? "Anonymous",
            profilePictureURL: data["profilePictureURL"] as? String ?? "",
            text: data["text"] as? String ?? "",
            userID: data["userID"] as? Int ?? -1
        )
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
        
        playAudio()
    }

    func playAudio() {
        guard let audioFilePath = Bundle.main.path(forResource: "sentmessage", ofType: "mp3") else {
            print("Audio file not found")
            return
        }
        
        let audioURL = URL(fileURLWithPath: audioFilePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }
}
