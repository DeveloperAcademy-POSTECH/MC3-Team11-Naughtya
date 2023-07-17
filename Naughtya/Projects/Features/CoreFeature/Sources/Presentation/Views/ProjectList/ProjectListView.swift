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

    @State private var projects: [Project] = []
    @State private var newProjectCategory: String = ""

    public init() {
    }

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
        .onAppear {
            Task {
                projects = try await Self.projectUseCase.readList()
            }
        }
    }

    private func appendNewProject() {
        Task {
            let project = try await Self.projectUseCase.create(
                category: newProjectCategory,
                goals: nil,
                startedAt: nil,
                endedAt: nil
            )
            projects.append(project)
            newProjectCategory = ""
        }
    }

    private func appendNewTodo(project: Project) {
        Task {
            let todo = try await Self.todoUseCase.create(project: project)
            project.todos.append(todo)
        }
    }

    private func buildProjectItem(_ project: Project) -> some View {
        VStack {
            HStack {
                Text(project.category)
                Text("\(project.completedTodos.count)/\(project.todos.count)")
                Button("추가") {
                    appendNewTodo(project: project)
                }
                Spacer()
            }
            TodoListView(todos: project.todos.reversed())
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
