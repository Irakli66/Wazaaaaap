import FirebaseFirestore
import SwiftUI
import AVFoundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    var emojiArray = ["like", "love", "beer", "cry", "devil"]
    var audioPlayer: AVAudioPlayer?
    let authManager = AuthenticationManager()
    
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
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.messages = documents.compactMap { doc in
                    self.createMessage(from: doc)
                }
                
                self.firstFetchedMessage = documents.first
                self.lastFetchedMessage = documents.last
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
                    print("No older messages available or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                guard !documents.isEmpty else {
                    print("No more older messages to fetch.")
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
                    print("No newer messages available or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                guard !documents.isEmpty else {
                    print("No more newer messages to fetch.")
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
        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
        let formattedTimestamp = formatTimestamp(timestamp)
        let emojiData = data["emoji"] as? [[String: Any]] ?? []
        let emoji = emojiData.compactMap { Emoji(name: $0["name"] as? String ?? "", count: $0["count"] as? Int ?? 0) }
        let id = data["userID"] as? String ?? ""
        
        return ChatMessage(
            id: doc.documentID,
            username: data["username"] as? String ?? "Anonymous",
            profilePictureURL: data["profilePictureURL"] as? String ?? "",
            text: data["text"] as? String ?? "",
            userID: id,
            timestamp: formattedTimestamp,
            emoji: emoji
        )
    }
    
    private func formatTimestamp(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Time" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func updateMessageProperty(messageID: String, emoji: String, count: Int) {
        let db = Firestore.firestore()
        
        let messageRef = db.collection("chats").document(chatRoomID).collection("messages").document(messageID)
        
        messageRef.updateData([
            "emoji": FieldValue.arrayUnion([Emoji(name: emoji, count: count + 1).toDictionary()])
        ]) { error in
            if let error = error {
                print("Error updating message: \(error.localizedDescription)")
            } else {
                print("Message property updated successfully")
            }
        }
    }
    
    func getEmojiCountByID(messageID: String, emoji: String) -> Int {
        messages.first(where: { $0.id == messageID })?.emoji.filter { $0.name == emoji }.count ?? 0
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else {
            print("Error: Message text is empty")
            return
        }
        
        guard let currentUser = authManager.getCurrentUser() else {
            print("Error: No user is currently logged in")
            return
        }
        
        let messageData: [String: Any] = [
            "username": currentUser.email ?? "Guest",
            "profilePictureURL": currentUser.photoUrl ?? "https://example.com/default-profile.jpg",
            "text": messageText,
            "userID": currentUser.uid,
            "timestamp": FieldValue.serverTimestamp(),
            "emoji": []
        ]
        
        db.collection("chats").document(chatRoomID).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent successfully")
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
