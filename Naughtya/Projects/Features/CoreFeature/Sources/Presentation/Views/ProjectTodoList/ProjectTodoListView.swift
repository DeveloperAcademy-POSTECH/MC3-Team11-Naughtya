//
//  ProjectTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectTodoListView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let projects: [ProjectModel]
    @State private var newProjectCategory: String = ""

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(projects) { project in
                buildProjectItem(project)
            }
        }
    }

    private func appendNewTodo(project: ProjectEntity) {
        Task {
            try Self.todoUseCase.create(
                project: project,
                dailyTodoList: nil
            )
        }
    }

    private func buildProjectItem(_ project: ProjectModel) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(project.category)
                    .font(.headline)
                Text("\(project.completedTodosCount)/\(project.totalTodosCount)")
                Button("Todo 추가") {
                    appendNewTodo(project: project.entity)
                }
                Spacer()
            }
            if !project.coldTodos.isEmpty {
                TodoListView(
                    todos: project.coldTodos,
                    isNested: true
                )
            }
        }
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView(projects: [])
    }
}
