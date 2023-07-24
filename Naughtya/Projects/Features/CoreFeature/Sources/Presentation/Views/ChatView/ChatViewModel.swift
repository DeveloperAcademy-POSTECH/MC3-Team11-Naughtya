//
//  ChatViewModel.swift
//  ChatGPTApp
//
//  Created by DongHyeok Kim on 2023/07/20.
//

import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = [Message(id: UUID(), role: .system, content: prompt, createAt: Date())]
        @Published var currentInput = "[ProjectUseCase의 category] TodoUseCase의 title"
        private let openAIService = OpenAIService()

        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""

            openAIService.sendMessage(messages: messages) { [weak self] response in
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }

                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())

                DispatchQueue.main.async {
                    self?.messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
