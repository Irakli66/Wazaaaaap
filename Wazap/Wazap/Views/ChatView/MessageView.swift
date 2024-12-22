//
//  ContentView.swift
//  wazaptest
//
//  Created by Beka on 21.12.24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.messages) { message in
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: message.profilePictureURL)) { image in
                                image.resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle().fill(Color.gray).frame(width: 40, height: 40)
                            }

                            VStack(alignment: .leading) {
                                Text("@\(message.username)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(message.text)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(5)
                    }
                }
                .onChange(of: viewModel.messages) { _ in
                    if let last = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("Type a message", text: $viewModel.messageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
        }
        .padding()
    }
}


#Preview {
    ChatView()
}
