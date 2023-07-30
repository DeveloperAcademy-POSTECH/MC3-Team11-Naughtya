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
        @Published var currentInput = ""
        private let openAIService = OpenAIService()

        func updateCurrentInput(with projectResult: ProjectResultModel) {
            print(currentInput)
        }

        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)

            Task {
                do {
                    let response = try await openAIService.sendMessage(messages: messages)
                    guard let receivedOpenAIMessage = response.choices.first?.message else {
                        print("Had no received message")
                        return
                    }

                    let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())

                    DispatchQueue.main.async {
                        self.messages.append(receivedMessage)
                    }
                } catch {
                    print("Error: \(error)")
                    // Handle the error as per your application's requirements
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
