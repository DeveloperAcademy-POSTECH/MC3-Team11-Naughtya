// swiftlint:disable all

import Foundation

struct OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Message]) async throws -> OpenAIChatResponse {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            throw DataError(message: "enviornment variables에 `OPENAI_API_KEY`를 추가해야 함")
        }

        let openAIMessages = messages.map { OpenAIChatMessage(role: $0.role, content: $0.content) }
        let body = OpenAIChatBody(
            model: "gpt-3.5-turbo",
            messages: openAIMessages,
            temperature: 0,
            max_tokens: 2000, // TODO: hayo
            top_p: 1 // TODO: hayo
        )

        guard let url = URL(string: endpointUrl) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
    }

}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
    let temperature: Float?
    let max_tokens: Int?
    let top_p: Float?
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

extension OpenAIChatResponse {
    struct OpenAIChatChoice: Decodable {
        let message: OpenAIChatMessage
    }
}
