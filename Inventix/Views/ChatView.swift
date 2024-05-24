//
//  ChatView.swift
//  Inventix
//
//  Created by Tri Tat on 5/15/24.
//

import SwiftUI
import MarkdownUI

struct ChatMessage: Identifiable {
    let id: UUID = UUID()
    let text: String
    let isFromUser: Bool
}

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @ObservedObject var store: InventoryViewModel
    var openAIManager: OpenAIManager 

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Type your message here...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)

                    Button(action: sendMessage) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                            .padding(.horizontal)
                    }
                }
                .frame(height: 50)
                .background(Color.secondary.opacity(0.1))
            }
            .navigationTitle("Chat")
            .navigationBarItems(trailing: Button("Close") { dismiss() })

        }
        .onAppear() {
            store.loadUserData()
        }
    }
        
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        let newMessage = ChatMessage(text: inputText, isFromUser: true)
        messages.append(newMessage)
        OpenAIManager.shared.sendProducts(store.products, store.categories, store.orders, ask: newMessage.text) { response in
                DispatchQueue.main.async {
                    if !response.isEmpty {
                        let responseMessage = ChatMessage(text: response, isFromUser: false)
                        messages.append(responseMessage)
                    } else {
                        let errorMessage = ChatMessage(text: "No response received or there was an error.", isFromUser: false)
                        messages.append(errorMessage)
                    }
                }
            }

            // Clear input text
            DispatchQueue.main.async {
                inputText = ""
            }
    }
}

struct ChatBubble: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            Markdown {
                message.text
            }
            .padding()
            .foregroundColor(Color.white)
            .background(message.isFromUser ? Color.accentColor : Color.blue)
            .cornerRadius(10)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
}
