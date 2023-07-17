//
//  DashboardView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct DashboardView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase.shared

    @State private var projects: [ProjectModel] = []
    @State private var completedTodos: [TodoModel] = []

    public init() {
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text("Completed")
                TodoListView(todos: completedTodos)
            }
            VStack {
                Text("Projects")
                ProjectListView(projects: projects)
            }
        }
        .onAppear {
            // TODO: observing 필요
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                fetchData()
            }
        }
    }

    private func fetchData() {
        Task {
            projects = try await Self.projectUseCase.readList()
                .map { .from(entity: $0) }
            completedTodos = projects
                .flatMap { $0.completedTodos }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
