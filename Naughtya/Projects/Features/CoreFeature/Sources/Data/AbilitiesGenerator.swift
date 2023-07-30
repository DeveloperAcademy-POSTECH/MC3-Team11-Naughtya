//
//  AbilitiesGenerator.swift
//  CoreFeature
//
//  Created by byo on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct AbilitiesGenerator {
    private static let openAIService = OpenAIService()

    let projectResult: ProjectResultEntity

    func generate() async throws -> [AbilityEntity] {
        let abilitiesForPerformance = try await fetchAbilities(category: .performance)
        let abilitiesForUncompleted = try await fetchAbilities(category: .uncompleted)
        return [abilitiesForPerformance, abilitiesForUncompleted]
            .flatMap { $0 }
    }

    private func fetchAbilities(category: AbilityCategory) async throws -> [AbilityEntity] {
        let answer = try await fetchAnswerFromOpenAI(category: category)
        let lines = answer
            .split(separator: "\n")
            .filter { !$0.isEmpty }
            .map { String($0) }
        let titleTodoStringsMap = getTitleTodoStringsMap(lines: lines)
        return titleTodoStringsMap
            .reduce([AbilityEntity]()) {
                $0 + [
                    AbilityEntity(
                        category: category,
                        title: $1.key,
                        todos: getTodos(titles: $1.value)
                    )
                ]
            }
    }

    private func fetchAnswerFromOpenAI(category: AbilityCategory) async throws -> String {
        let messages = getMessagesForOpenAI(category: category)
        let response = try await Self.openAIService.sendMessage(messages: messages)
        guard let answer = response.choices.last?.message.content else {
            throw DataError(message: "gpt가 말을 안함")
        }
        return answer
    }

    private func getMessagesForOpenAI(category: AbilityCategory) -> [Message] {
        [
            Message(
                id: UUID(),
                role: .system,
                content: category.gaslighting,
                createAt: .now
            ),
            Message(
                id: UUID(),
                role: .user,
                content: getTodosSummary(category: category),
                createAt: .now
            )
        ]
    }

    private func getTodosSummary(category: AbilityCategory) -> String {
        switch category {
        case .performance:
            return projectResult.completedTodosSummary
        case .uncompleted:
            return projectResult.uncompletedTodosSummary
        }
    }

    private func getTitleTodoStringsMap(lines: [String]) -> [String: [String]] {
        var result = [String: [String]]()
        var title = ""
        for line in lines {
            if line.last == ":" {
                title = line.replacingOccurrences(of: ":", with: "")
                result[title] = []
            } else if line.first == "-" {
                result[title]?.append(line.replacingOccurrences(of: "- ", with: ""))
            }
        }
        return result
    }

    private func getTodos(titles: [String]) -> [TodoEntity] {
        let titleTodoMap = projectResult.project.todos.value
            .reduce([String: TodoEntity]()) {
                var result = $0
                result[$1.title.value] = $1
                return result
            }
        return titles
            .compactMap { titleTodoMap[$0] }
    }
}
