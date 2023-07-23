//
//  ProjectResultListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultListView: View {
    private static let projectResultUseCase: ProjectResultUseCase = MockProjectResultUseCase()

    @State private var projectResults: [ProjectResultModel] = []

    public init() {
    }

    public var body: some View {
        HStack {
            ForEach(projectResults) { projectResult in
                VStack {
                    Text(projectResult.project.category)
                        .font(.headline)
                    Text("전체 : \(projectResult.project.totalTodosCount)")
                    Text("완료 : \(projectResult.project.completedTodosCount)")
                    Text("안미룸 : \(projectResult.dailyCompletedTodosCount)")
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
