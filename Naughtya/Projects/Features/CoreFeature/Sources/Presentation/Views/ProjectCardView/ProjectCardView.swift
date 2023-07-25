//
//  ProjectCardView.swift
//  MacOSCoreFeature
//
//  Created by Greed on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectCardView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    public let project: ProjectModel

    private let cornerRadius: CGFloat = 16

    var projectEndDay: Date {
        project.endedAt! // TODO: 기획 확정 후 수정
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: project.isBookmarked ? "star.fill" : "star")
                    .foregroundColor(project.isBookmarked ? .yellow : .white)
                    .onTapGesture {
                        toggleIsBookmarked()
                    }
                Text("\(Date().dDayCalculater(projectEndDay: projectEndDay))")
                Spacer()
                Text("~\(changeDateFormat())")
            }

            HStack(spacing: 0.0) {
                Text(project.category)
                    .font(.largeTitle)
                Spacer()
                Text("\(project.completedTodos.count)")
                    .font(.largeTitle)
                Text("/\(project.todos.count)")
            }
        }
        .foregroundColor(.white)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(project.isSelected ? Color.blue : Color.gray)
        )
        .onTapGesture {
            Task {
                try await Self.projectUseCase.toggleSelected(
                    project.entity,
                    isSelected: !project.isSelected
                )
            }
        }
    }

    func toggleIsBookmarked() {
        Task {
            try await Self.projectUseCase.toggleIsBookmarked(
                project.entity,
                isBookmarked: !project.isBookmarked)
        }
    }

    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)

        return formattedDate
    }
}
