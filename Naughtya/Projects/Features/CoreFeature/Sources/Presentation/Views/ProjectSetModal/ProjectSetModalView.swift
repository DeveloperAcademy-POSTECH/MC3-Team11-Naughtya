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

    let project: ProjectModel?
    @State private var newProjectCategory: String = ""
    @State private var newProjectGoal: String = ""
    @State private var projectStartDay = Date()
    @State private var projectEndDay = Date()
    @Environment(\.dismiss) private var dismiss

    init(project: ProjectModel? = nil) {
        self.project = project
    }

    var body: some View {
        VStack(spacing: 55) {
            VStack(spacing: 20) {
                buildTextView(
                    title: "프로젝트 이름",
                    placeholder: "나의 프로젝트 이름 생성하기 (10자 이내)",
                    text: $newProjectCategory
                )
                buildTextView(
                    title: "프로젝트 목표",
                    subtitle: "(선택)",
                    placeholder: "나의 프로젝트 목표 생성하기 (50자 이내)",
                    text: $newProjectGoal
                )
                VStack(alignment: .leading, spacing: 10) {
                    Text("프로젝트 기간")
                        .font(.appleSDGothicNeo(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    HStack(alignment: .bottom, spacing: 17) {
                        buildDatePicker(isStarting: true)
                        Text("~")
                            .font(.appleSDGothicNeo(size: 20, weight: .bold))
                            .foregroundColor(.customGray6)
                            .frame(height: 43)
                        buildDatePicker(isStarting: false)
                    }
                }
            }
            HStack(spacing: 12) {
                Spacer()
                buildButton(
                    title: "취소",
                    foregroundColor: .black,
                    backgroundColor: .customGray2
                ) {
                    dismiss()
                }
                buildButton(
                    title: "저장",
                    foregroundColor: .white,
                    backgroundColor: .pointColor
                ) {
                    if project == nil {
                        appendNewProject()
                    } else {
                        if let project = project {
                            update(project.entity)
                        }
                    }
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 52)
        .padding(.bottom, 23)
        .frame(width: 413, height: 407)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.customGray9)
        )
        .onAppear {
            setupProjectIfNeeded()
        }
    }

    private func buildTextView(
        title: String,
        subtitle: String? = nil,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .foregroundColor(Color.customGray6)
                }
            }
            TextField(text: text) {
                Text(placeholder)
                    .foregroundColor(Color.customGray2)
            }
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .frame(height: 36)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.customGray7)
            )
        }
        .font(.appleSDGothicNeo(size: 14))
    }

    private func buildDatePicker(isStarting: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(isStarting ? "시작" : "종료")
                .font(.appleSDGothicNeo(size: 12))
                .foregroundColor(.customGray1)
            Group {
                if isStarting {
                    DatePicker(
                        "",
                        selection: $projectStartDay,
                        in: ...projectEndDay,
                        displayedComponents: [.date]
                    )
                } else {
                    DatePicker(
                        "",
                        selection: $projectEndDay,
                        in: projectStartDay...,
                        displayedComponents: [.date]
                    )
                }
            }
            .datePickerStyle(.field)
            .labelsHidden()
            .padding(.horizontal, 16)
            .frame(height: 43)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGray6, lineWidth: 1)
            )
        }
    }

    private func buildButton(
        title: String,
        foregroundColor: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundColor(foregroundColor)
                .frame(
                    width: 60,
                    height: 24
                )
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(backgroundColor)
                )
        }
        .buttonStyle(.plain)
    }

    private func setupProjectIfNeeded() {
        guard let project = project else {
            return
        }
        newProjectCategory = project.category
        newProjectGoal = project.goals ?? ""
        projectStartDay = project.startedAt ?? Date()
        projectEndDay = project.endedAt ?? Date()
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
