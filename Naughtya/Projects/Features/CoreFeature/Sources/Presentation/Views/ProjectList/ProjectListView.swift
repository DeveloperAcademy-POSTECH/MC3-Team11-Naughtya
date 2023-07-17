//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase.shared
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let projects: [ProjectModel]
    @State private var newProjectCategory: String = ""

    public var body: some View {
        List {
            ForEach(projects) { project in
                buildProjectItem(project)
            }
            HStack {
                TextField(text: $newProjectCategory) {
                    Text("새 프로젝트")
                }
                Button("추가") {
                    appendNewProject()
                }
                Spacer()
            }
        }
    }

    private func appendNewProject() {
        Task {
            try await Self.projectUseCase.create(
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
            try await Self.todoUseCase.create(project: project)
        }
    }

    private func buildProjectItem(_ project: ProjectModel) -> some View {
        VStack {
            HStack {
                Text(project.category)
                Text("\(project.completedTodos.count)/\(project.todos.count)")
                Button("추가") {
                    appendNewTodo(project: project.entity)
                }
                Spacer()
            }
            TodoListView(todos: project.todos.reversed())
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [])
    }
}
