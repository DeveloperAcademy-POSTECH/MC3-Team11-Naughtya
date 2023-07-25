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

    let cornerRadius: CGFloat = 16

    var projectName: String {
        project.category
    }

    var projectEndDay: Date {
        project.endedAt! // TODO: 기획 확정 후 수정
    }

    var completedTodosCount: Int {
        project.completedTodosCount
    }

    var totalTodosCount: Int {
        project.totalTodosCount
    }

    var isSelected: Bool {
        project.isSelected
    }

    var isBookmarked: Bool {
        project.isBookmarked
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: isBookmarked ? "star.fill" : "star")
                    .foregroundColor(isBookmarked ? .yellow : .white)
                    .onTapGesture {
                        toggleIsBookmarked()
                    }
                Text("\(Date().dDayCalculater(projectEndDay: projectEndDay))")
                Spacer()
                Text("~\(changeDateFormat())")
            }

            HStack(spacing: 0.0) {
                Text(projectName)
                    .font(.largeTitle)
                Spacer()
                Text("\(completedTodosCount)")
                    .font(.largeTitle)
                Text("/\(totalTodosCount)")
            }
        }
        .foregroundColor(.white)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? Color.blue : Color.gray)
        )
        .onTapGesture {
            Task {
                try Self.projectUseCase.toggleSelected(
                    project.entity,
                    isSelected: !isSelected
                )
            }
        }
    }

    func toggleIsBookmarked() {
        Task {
            try Self.projectUseCase.toggleIsBookmarked(
                project.entity,
                isBookmarked: !isBookmarked)
        }
    }
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)

        return formattedDate
    }
}
