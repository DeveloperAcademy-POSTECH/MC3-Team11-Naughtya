//
//  ProjectResultGenerator.swift
//  CoreFeature
//
//  Created by byo on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct ProjectResultGenerator {
    private static let openAIService = OpenAIService()

    let project: ProjectEntity

    func generate() async throws -> ProjectResultEntity {
        let abilities = try await fetchAbilities()
        let projectResult = ProjectResultEntity(
            project: project,
            abilities: abilities
        )
        return projectResult
    }

    private func fetchAbilities() async throws -> [AbilityEntity] {
        let performance = try await fetchAbility(category: .performance)
        let delayed = try await fetchAbility(category: .delayed)
        let uncompleted = try await fetchAbility(category: .uncompleted)
        return [performance, delayed, uncompleted]
    }

    private func fetchAbility(category: AbilityCategory) async throws -> AbilityEntity {
        let answer = try await fetchAnswerFromOpenAI(category: category)
        let todos = getTodos(category: category)
        let ability = AbilityEntity(
            category: category,
            title: answer,
            todos: todos
        )
        return ability
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
        let todos = getTodos(category: category)
        let summary = todos
            .reduce("") {
                $0 + "- \($1.title.value)\n"
            }
        return summary
    }

    private func getTodos(category: AbilityCategory) -> [TodoEntity] {
        switch category {
        case .performance:
            return project.todos.value
        case .delayed:
            return project.todos.value
        case .uncompleted:
            return project.todos.value
        case .sample:
            return []
        }
    }
}
