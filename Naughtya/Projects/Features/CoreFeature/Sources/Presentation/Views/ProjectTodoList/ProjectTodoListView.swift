//
//  ProjectTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectTodoListView: View {
    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    public var body: some View {
        VStack(spacing: 16) {
                ForEach(projects.filter { $0.isSelected }) { project in
                    ProjectItemView(project: project)
                }
        }
    }

    private func buildProjectItem(_ project: ProjectModel) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(project.category)
                    .font(.headline)
                Text("\(project.completedTodos.count)/\(project.todos.count)")
                Spacer()
            }
            if !project.backlogTodos.isEmpty {
                TodoListView(todos: project.backlogTodos)
            }
        }
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
