import Foundation

class OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Message], completion: @escaping (OpenAIChatResponse?) -> Void) {
        let openAIMessages = messages.map { OpenAIChatMessage(role: $0.role, content: $0.content) }
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages, temperature: 1)

        guard let url = URL(string: endpointUrl) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(nil)
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
                completion(response)
            } catch {
                completion(nil)
            }
        }

        task.resume()
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
    let temperature: Float?
//    let max_tokens: Int
//    let top_p: Float?
    // tuist규칙때문에 이게 불가능한데 나는 api요청을 해야하는데... 흠..
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
