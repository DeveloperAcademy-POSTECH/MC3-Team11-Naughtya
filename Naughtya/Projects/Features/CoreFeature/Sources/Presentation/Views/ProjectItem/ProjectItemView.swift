//
//  ProjectItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectItemView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let project: ProjectModel

    public init(project: ProjectModel) {
        self.project = project
    }

    public var body: some View {
        VStack {
            HStack {
                Text(project.category)
                    .font(.headline)
                Text("\(project.completedTodosCount)/\(project.totalTodosCount)")
                Button("Todo 추가") {
                    appendNewTodo(project: project.entity)
                }
                Spacer()
            }
            TodoListView(
                section: project.entity,
                todos: project.coldTodos
            )
        }
    }

    private func appendNewTodo(project: ProjectEntity) {
        Task {
            try await Self.todoUseCase.create(
                project: project,
                dailyTodoList: nil
            )
        }
    }
}
