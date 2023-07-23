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
        project.endedAt!
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
                Text("\(dDayCalculater())")
                Spacer()
                Text("~\(changeDateFormat())")
            }
            Spacer().frame(height: 20)
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

    func dDayCalculater() -> String {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let projectEndDate = calendar.startOfDay(for: projectEndDay)

        let components = calendar.dateComponents([.day], from: currentDate, to: projectEndDate)

        if let days = components.day {
            if days == 0 {
                return "D-day"
            } else if days > 0 {
                return "D-\(days)"
            } else {
                return "D+\(-days)"
            }
        } else {
            return "날짜 계산 오류"
        }
    }
}

// struct ProjectCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectCardView()
//    }
// }
