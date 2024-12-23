//
//  ChatView.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import SwiftUI
import Kingfisher

struct ChatView: View {
    @AppStorage("selectedLanguage") var selectedLanguageRawValue: String = AppLanguage.english.rawValue
    @StateObject private var viewModel = ChatViewModel()
    @State var visibleEmojiMessageID: String?
    @State private var scrollProxy: ScrollViewProxy?
    @State private var shouldAutoScroll = true
    let currentUser = AuthenticationManager().getCurrentUser()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Image("logo")
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        NavigationLink(destination: ProfileView()) {
                            Image("Settings")
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 15)
                    .background(.customBackground)
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        if geometry.frame(in: .named("scroll")).minY >= 0 {
                                            viewModel.fetchOlderMessages()
                                        }
                                    }
                            }
                            .frame(height: 1)
                            
                            ForEach(viewModel.messages) { message in
                                HStack(alignment: .top, spacing: 8) {
                                    HStack {
                                        if message.userID == currentUser?.uid {
                                            Spacer()
                                            VStack(alignment: .trailing, spacing: 2) {
                                                Text(message.text)
                                                
                                                HStack {
                                                    Text(message.timestamp)
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(.textBg)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        } else {
                                            HStack {
                                                VStack {
                                                    KFImage(URL(string: message.profilePictureURL))
                                                        .resizable()
                                                        .placeholder {
                                                            Image("Avatar")
                                                                .resizable()
                                                                .scaledToFill()
                                                        }
                                                        .scaledToFill()
                                                        .frame(width: 32, height: 32)
                                                        .background(.green)
                                                        .clipShape(Circle())
                                                    
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading) {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        VStack(alignment: .leading, spacing: 2) {
                                                            Text("@\(message.username)")
                                                                .foregroundStyle(.customBlue)
                                                            
                                                            Text(message.text)
                                                            
                                                            Text(message.timestamp)
                                                                .font(.caption)
                                                                .foregroundColor(.gray)
                                                        }
                                                        .padding(.horizontal, 12)
                                                        .padding(.top, 8)
                                                        .padding(.bottom, 20)
                                                        .frame(minWidth: 150, alignment: .leading)
                                                        .background(.customBackground)
                                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                                        .onLongPressGesture(minimumDuration: 1) {
                                                            visibleEmojiMessageID = message.id
                                                            shouldAutoScroll = false
                                                        }
                                                        
                                                        LazyVGrid(
                                                            columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3),
                                                            spacing: 4
                                                        ) {
                                                            ForEach(message.emojiArray) { emoji in
                                                                HStack(spacing: 4) {
                                                                    Image(emoji.name)
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    
                                                                    if emoji.count > 1 {
                                                                        Text("\(emoji.count)")
                                                                            .font(.system(size: 13))
                                                                            .fixedSize()
                                                                    }
                                                                }
                                                                .padding(.vertical, 6)
                                                                .padding(.horizontal, 8)
                                                                .background(.white)
                                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                                .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
                                                            }
                                                        }
                                                        .padding(.top, -12)
                                                        .frame(maxWidth: 150, alignment: .leading)
                                                    }
                                                    .frame(maxWidth: 263, alignment: .leading)
                                                    
                                                    HStack(alignment: .center) {
                                                        ForEach(viewModel.emojiArray, id: \.self) { emoji in
                                                            Button {
                                                                viewModel.updateMessageProperty(messageID: message.id, emoji: emoji, count: viewModel.getEmojiCountByID(messageID: message.id, emoji: emoji))
                                                                visibleEmojiMessageID = nil
                                                            } label: {
                                                                Image(emoji)
                                                            }
                                                        }
                                                    }
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(.customBackground)
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                                                    .frame(height: visibleEmojiMessageID == message.id ? 40 : 0)
                                                    .scaleEffect(visibleEmojiMessageID == message.id ? 1.0 : 0.0)
                                                    .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0), value: visibleEmojiMessageID)
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 12)
                                .id(message.id)
                                
                                Spacer()
                                    .frame(height: 16)
                            }
                            
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        if geometry.frame(in: .named("scroll")).maxY <= UIScreen.main.bounds.height {
                                            viewModel.fetchNewerMessages()
                                        }
                                    }
                            }
                            .frame(height: 1)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onChange(of: viewModel.messages) { _, newMessages in
                            if shouldAutoScroll, let lastMessage = newMessages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .scrollIndicators(.hidden)
                    .onAppear {
                        scrollProxy = proxy
                        shouldAutoScroll = true
                        viewModel.fetchInitialMessages()
                    }
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            shouldAutoScroll = false
                        }
                    )
                }
                
                Divider()
                
                HStack {
                    TextField(
                        selectedLanguageRawValue == "English" ? "Type a message..." : "მისწერე დეპეშა",
                        text: $viewModel.messageText
                    )
                    .frame(height: 36)
                    .padding(.leading, 12)
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .cornerRadius(20)
                    
                    Button(action: {
                        Task {
                            await viewModel.sendMessage()
                            shouldAutoScroll = true
                        }
                    }) {
                        Image("sendButton")
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 34)
                .padding(.top, 8)
            }
            .onTapGesture {
                visibleEmojiMessageID = nil
            }
        }
    }
}
