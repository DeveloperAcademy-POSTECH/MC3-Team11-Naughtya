//
//  ProjectSetModal.swift
//  CoreFeature
//
//  Created by Greed on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectSetModalView: View {

    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()

    @Environment(\.dismiss) private var dismiss

    @State private var newProjectCategory: String = ""
    @State private var newProjectGoal: String = ""
    @State private var projectStartDay = Date()
    @State private var projectEndDay = Date()
    var isSelected: Bool = false
    var isBookmarked: Bool = false

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("프로젝트 제목")
                TextField(text: $newProjectCategory) {
                    Text("나의 프로젝트 이름 생성하기")
                }
                Text("프로젝트 목표")
                TextField(text: $newProjectGoal) {
                    Text("나의 프로젝트 목표 생성하기")
                }
                Text("프로젝트 기간")
                HStack {
                    VStack(alignment: .leading) {
                        Text("시작")
                            .font(.caption)
                        DatePicker("", selection: $projectStartDay, displayedComponents: [.date])
                            .datePickerStyle(.field)
                    }
                    VStack {
                        Spacer().frame(height: 10)
                        Text("~")
                    }
                    VStack(alignment: .leading) {
                        Text("종료")
                            .font(.caption)
                        DatePicker("", selection: $projectEndDay, displayedComponents: [.date])
                            .datePickerStyle(.field)
                    }
                }
            }
            Button("새 프로젝트 생성하기") {
                appendNewProject()
                dismiss()
            }
        }
        .padding()
        .frame(width: 421)
    }
    private func appendNewProject() {
        Task {
            try Self.projectUseCase.create(
                category: newProjectCategory,
                goals: newProjectGoal,
                startedAt: projectStartDay,
                endedAt: projectEndDay,
                isSelected: isSelected,
                isBookmarked: isBookmarked
            )
            newProjectCategory = ""
            newProjectGoal = ""
        }
    }
}

struct ProjectSetModal_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSetModalView()
    }
}
