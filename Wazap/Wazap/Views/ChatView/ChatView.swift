//
//  ChatView.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import SwiftUI
import Kingfisher

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State var visibleEmojiMessageID: String?
    @State private var textHeight: CGFloat = 40
    
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
//                                                        viewModel.reactOnMessage(emoji: emoji, messageID: message.id)
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
                }
                .onChange(of: viewModel.messages) {
                    if let last = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollIndicators(.hidden)
            }
            
            HStack {
                TextEditor(text: $viewModel.messageText)
                    .frame(height: max(40, min(textHeight, 120)))
                    .cornerRadius(10)
                    .scrollIndicators(.hidden)
                    .autocorrectionDisabled()
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(Color(.systemGray6))
                    .onChange(of: viewModel.messageText) {
                        calculateTextHeight()
                    }
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image("sendButton")
                }
            }
            .padding(.horizontal, 15)
        }
        .onTapGesture {
            visibleEmojiMessageID = nil
        }
    }
    
    private func calculateTextHeight() {
        let size = CGSize(width: UIScreen.main.bounds.width - 80, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: viewModel.messageText).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        textHeight = max(40, estimatedFrame.height + 16)
    }
}


#Preview {
    ChatView()
}
