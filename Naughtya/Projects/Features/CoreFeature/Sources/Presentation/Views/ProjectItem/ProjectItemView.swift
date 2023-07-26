//
//  ProjectItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectItemView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()
    @State private var selectedSortOption = 0
    private let sortOptions = ["전체보기", "완료 todo", "미완료 todo"]

    public let project: ProjectModel

    public init(project: ProjectModel) {
        self.project = project
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack {
                HStack {
                    Text(project.category)
                        .font(
                            Font.custom("SF Pro", size: 24)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)

                    Spacer()

                    Picker(selection: $selectedSortOption, label: Text("")) {
                                        ForEach(0..<sortOptions.count) { index in
                                            Text(sortOptions[index])
                                        }
                                    }
                                    .frame(width: 110)
                                    .pickerStyle(DefaultPickerStyle()) // 변경된 부분
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 40)
                }
                HStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 22, height: 22)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    if let goals = project.goals, !goals.isEmpty {
                        Text(goals)
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .frame(width: 360, alignment: .leading)
                    } else {
                        Text("(선택) 목표를 입력해 보세요.")
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                            .frame(width: 360, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, 20)
            TodoListView(
                section: project.entity,
                todos: project.backlogTodos
            )
            Button("Todo 추가") {
                appendNewTodo(project: project.entity)
            }
        }
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
        .padding(.horizontal, 20)
        .frame(alignment: .topLeading)
    }

    private func appendNewTodo(project: ProjectEntity) {
        Task {
            try await Self.todoUseCase.create(
                project: project,
                dailyTodoList: nil
            )
        }
    }
}
