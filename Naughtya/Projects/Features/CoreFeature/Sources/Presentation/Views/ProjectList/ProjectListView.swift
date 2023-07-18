//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let projects: [ProjectModel]
    @State private var newProjectCategory: String = ""

    public init(projects: [ProjectModel]) {
        self.projects = projects
    }

    public var body: some View {
        VStack(spacing: 16) {
            projectInputView
            ForEach(projects) { project in
                buildProjectItem(project)
            }
        }
    }

    private var projectInputView: some View {
        HStack {
            TextField(text: $newProjectCategory) {
                Text("Category")
            }
            Button("Project 추가") {
                appendNewProject()
            }
            Spacer()
        }
    }

    private func appendNewProject() {
        Task {
            try Self.projectUseCase.create(
                category: newProjectCategory,
                goals: nil,
                startedAt: nil,
                endedAt: nil
            )
            newProjectCategory = ""
        }
    }

    private func appendNewTodo(project: ProjectEntity) {
        Task {
            try Self.todoUseCase.create(
                project: project,
                isDaily: false
            )
        }
    }

    private func buildProjectItem(_ project: ProjectModel) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(project.category)
                    .font(.headline)
                Text("\(project.completedTodos.count)/\(project.todos.count)")
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

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [])
    }
}
