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
                        text: data["text"] as? String ?? "",
                        userID: data["userID"] as? Int ?? -1
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
    
    func reactOnMessage(emoji: String, messageID: Int) {
        print("emoji: \(emoji) and mesasge id: \(messageID)")
    }
}
