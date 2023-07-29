//
//  ProjectResultListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultListView: View {
    private static let projectResultUseCase: ProjectResultUseCase = DefaultProjectResultUseCase()

    @State private var projectResults: [ProjectResultModel] = []

    public init() {
    }

    public var body: some View {
        HStack {
            ForEach(projectResults) { projectResult in
                VStack {
                    Text("\(projectResult.projectName) 프로젝트")
                        .font(.headline)
                    Text("\(projectResult.daysInProject)일간의 여정")
                    Text("\(projectResult.abilitiesCount)개의 능력을 획득 했어요")
                    Text("평균 To-do 달성률 \(projectResult.completedPercent)%")
                    Text("달성 To-do 갯수 \(projectResult.completedCount)/\(projectResult.allTodosCount)")
                    Text("Top3 미룬 To-do")
                    ForEach(projectResult.top3DelayedTodos) { todo in
                        Text("\(todo.title) \(todo.delayedCount)")
                    }
                    Text("미완료 To-do \(projectResult.uncompletedTodos.count)")
                    Button("Result 생성") {
                        let generator = ProjectResultGenerator(project: projectResult.project.entity)
                        Task {
                            print("@LOG result start")
                            let result = try await generator.generate()
                            print("@LOG result end \(result.abilities.value)")
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchProjectResults()
        }
    }

    private func fetchProjectResults() {
        Task {
            projectResults = try await Self.projectResultUseCase.readList()
                .map { .from(entity: $0) }
        }
    }
}

struct ProjectResultListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectResultListView()
    }
}
