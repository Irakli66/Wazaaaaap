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
                                    .background(.customBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                } else {
                                    VStack {
                                        KFImage(URL(string: message.profilePictureURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 32, height: 32)
                                            .background(.green)
                                            .clipShape(Circle())
                                        
                                        Spacer()
                                    }
                                    
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
                                    
                                    Spacer()
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
                .padding(.bottom, 28)
            }
            
            HStack {
                TextField("Type a message", text: $viewModel.messageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
    }
}


#Preview {
    ChatView()
}
