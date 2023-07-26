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

    @State private var newProjectCategory: String
    @State private var newProjectGoal: String
    @State private var projectStartDay = Date()
    @State private var projectEndDay = Date()

    private let project: ProjectModel?

    init(project: ProjectModel? = nil) {
        self.project = project
        if let project = project {
            self._newProjectCategory = State(initialValue: project.category)
            self._newProjectGoal = State(initialValue: project.goals ?? "")
            self._projectStartDay = State(initialValue: project.startedAt ?? Date())
            self._projectEndDay = State(initialValue: project.endedAt ?? Date())
        } else {
            self._newProjectCategory = State(initialValue: "")
            self._newProjectGoal = State(initialValue: "")
            self._projectStartDay = State(initialValue: Date())
            self._projectEndDay = State(initialValue: Date())
        }
    }

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
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    if project == nil {
                        appendNewProject()
                    } else {
                        if let project = project {
                            update(project.entity)
                        }
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(minWidth: 300)
    }

    private func appendNewProject() {
        Task {
            try await Self.projectUseCase.create(
                category: newProjectCategory,
                goals: newProjectGoal,
                startedAt: projectStartDay,
                endedAt: projectEndDay
            )
            newProjectCategory = ""
            newProjectGoal = ""
        }
    }

    private func update(_ project: ProjectEntity) {
        Task {
            try await Self.projectUseCase.update(
                _: project,
                category: newProjectCategory,
                goals: newProjectGoal,
                startedAt: projectStartDay,
                endedAt: projectEndDay
            )
        }
    }
}

struct ProjectSetModal_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSetModalView()
    }
}
