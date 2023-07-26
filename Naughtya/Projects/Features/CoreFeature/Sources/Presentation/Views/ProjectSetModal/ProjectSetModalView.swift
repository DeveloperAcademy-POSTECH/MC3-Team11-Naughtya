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
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("프로젝트 제목")
                      .font(
                        Font.custom("SF Pro", size: 14)
                          .weight(.medium)
                      )
                      .foregroundColor(.white)

                    TextField(text: $newProjectCategory) {
                        Text("나의 프로젝트 이름 생성하기")
                            .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                    }
                    .foregroundColor(Color.white)
                    .cornerRadius(6.38361)
                    Text("프로젝트 목표(선택)")
                      .font(
                        Font.custom("SF Pro", size: 14)
                          .weight(.medium)
                      )
                      .foregroundColor(.white)

                    TextField(text: $newProjectGoal) {
                        Text("나의 프로젝트 목표 생성하기")
                            .foregroundColor(Color(red: 0.16, green: 0.16, blue: 0.16))
                    }
                    .foregroundColor(Color.white)
                    .cornerRadius(6.38361)

                    Text("프로젝트 기간")
                      .font(
                        Font.custom("SF Pro", size: 14)
                          .weight(.medium)
                      )
                      .foregroundColor(.white)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("시작")
                              .font(Font.custom("Apple SD Gothic Neo", size: 12))
                              .foregroundColor(Color(red: 0.69, green: 0.68, blue: 0.68))
                            DatePicker("", selection: $projectStartDay, displayedComponents: [.date])
                                .datePickerStyle(.field)
                                .background(Color.backgroundColor)
                        }
                        VStack {
                            Spacer().frame(height: 10)
                            Text("~")
                        }
                        VStack(alignment: .leading) {
                            Text("종료")
                                .font(Font.custom("Apple SD Gothic Neo", size: 12))
                                .foregroundColor(Color(red: 0.69, green: 0.68, blue: 0.68))
                            DatePicker("", selection: $projectEndDay, displayedComponents: [.date])
                                .datePickerStyle(.field)
                                .background(Color.backgroundColor)
                        }
                    }
                }
                Spacer().frame(height: 67.5)
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
        .frame(width: 413, height: 426)
        }
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
