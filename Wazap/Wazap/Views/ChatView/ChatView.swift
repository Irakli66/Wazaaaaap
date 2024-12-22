//
//  ChatView.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Image("logo")
                    .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    print("tapped")
                } label: {
                    Image("Settings")
                }
                .frame(width: 32, height: 32)
            }
            .padding(.bottom, 23)
            .padding(.horizontal, 15)
            .background(.customBackground)
            
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
                                    if message.userID == 1 {
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(message.text)
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
                                                        Image("noAvatar")
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
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("@\(message.username)")
                                                        .foregroundStyle(.customBlue)
                                                    Text(message.text)
                                                }
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(.customBackground)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                .frame(maxWidth: 262, alignment: .leading)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .onLongPressGesture(minimumDuration: 1) {
                                                    visibleEmojiMessageID = message.id
                                                }
                                                
                                                HStack(alignment: .center) {
                                                    ForEach(viewModel.emojiArray, id: \.self) { emoji in
                                                        Button {
                                                            print("Reacted with \(emoji)")
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
                    .onChange(of: viewModel.messages) {
                        if let last = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .frame(maxWidth: .infinity)
                .scrollIndicators(.hidden)
                .onAppear {
                    viewModel.fetchInitialMessages()
                }
            }
            
            Divider()
            
            HStack {
                TextField("Type a message...", text: $viewModel.messageText)
                    .frame(height: 36)
                    .padding(.leading, 12)
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .cornerRadius(20)
                
                Button(action: {
                    viewModel.sendMessage()
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

#Preview {
    ChatView()
}
