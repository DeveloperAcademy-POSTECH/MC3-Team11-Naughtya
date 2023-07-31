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
        ScrollView {
            HStack {
                ForEach(projectResults) { projectResult in
                    VStack(alignment: .leading) {
                        Text("\(projectResult.projectName) 프로젝트")
                        Text("\(projectResult.daysInProject)일간의 여정")
                        if projectResult.isGenerated {
                            Text("\(projectResult.abilitiesCount)개의 능력을 획득 했어요")
                            ForEach(projectResult.abilities) { ability in
                                Text("- \(ability.title) 총 \(ability.todos.count)개")
                            }
                            Text("평균 To-do 달성률 \(projectResult.completedPercent)%")
                            Text("달성 To-do 갯수 \(projectResult.completedCount)/\(projectResult.allTodosCount)")
                            Text("Top3 미룬 To-do")
                            ForEach(projectResult.top3DelayedTodos) { todo in
                                Text("- \(todo.title) 총 \(todo.delayedCount)회")
                            }
                            Text("미완료 To-do \(projectResult.incompletedTodos.count)")
                        } else {
                            Text("리포트 생성중 🙂")
                        }
                        CreditsTodoListView(projectResult: projectResult)
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
