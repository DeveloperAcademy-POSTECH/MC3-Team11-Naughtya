//
//  ProjectSetModal.swift
//  CoreFeature
//
//  Created by Greed on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectSetModalView: View {

    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()

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
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("프로젝트 이름")
                        .font(Font.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(.white)
                    TextField(text: $newProjectCategory) {
                        Text("나의 프로젝트 이름 생성하기 (10자 이내)")
                            .foregroundColor(Color.customGray2)
                    }
                    .font(Font.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color.white)
                    .cornerRadius(6.38361)
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 0) {
                        Text("프로젝트 목표")
                            .font(Font.custom("Apple SD Gothic Neo", size: 14))
                            .foregroundColor(.white)
                        Text("(선택)")
                            .font(Font.custom("Apple SD Gothic Neo", size: 14))
                            .foregroundColor(Color.customGray6)
                    }
                    TextField(text: $newProjectGoal) {
                        Text("나의 프로젝트 목표 생성하기 (50자 이내)")
                            .foregroundColor(Color.customGray2)
                    }
                    .font(Font.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color.white)
                    .cornerRadius(6.38361)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("프로젝트 기간")
                        .font(Font.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(.white)
                    HStack(alignment: .bottom, spacing: 17) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("시작")
                                .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                .foregroundColor(Color.customGray1)
                            DatePicker("", selection: $projectStartDay, in: ...projectEndDay, displayedComponents: [.date])
                                .datePickerStyle(.field)
                        }
                        VStack {
                            Text("~")
                                .font(
                                    Font.custom("Apple SD Gothic Neo", size: 20)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color.customGray6)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("종료")
                                .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                .foregroundColor(Color.customGray1)
                            DatePicker("", selection: $projectEndDay, in: projectStartDay..., displayedComponents: [.date])
                                .datePickerStyle(.field)
                        }
                    }

                }
                Spacer().frame(height: 35)
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
            .padding(.horizontal, 20)
            .padding(.top, 52)
            .padding(.bottom, 32)
            .frame(width: 350, height: 350)
            .cornerRadius(15)
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
