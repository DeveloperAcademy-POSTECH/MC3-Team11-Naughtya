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

        HStack(alignment: .center) {
          // Space Between
            VStack(alignment: .leading, spacing: 18) {
                Text(project.category)
                    .font(
                        Font.custom("SF Pro", size: 24)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                HStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 22, height: 22)
                        .background(Color.customGray1)
                    if let goals = project.goals, !goals.isEmpty {
                        Text(goals)
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(Color.customGray2)
                            .frame(width: 360, alignment: .leading)
                    } else {
                        Text("(선택) 목표를 입력해 보세요.")
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(Color.customGray2)
                            .frame(width: 360, alignment: .leading)
                    }
                }

            }
            .padding(0)
            .frame(width: 300, alignment: .topLeading)
          Spacer()
          // Alternative Views and Spacers
            Picker(selection: $selectedSortOption, label: Text("")) {
                ForEach(0..<sortOptions.count) { index in
                    Text(sortOptions[index])
                }
            }
            .frame(width: 110)
            .pickerStyle(DefaultPickerStyle())
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 40)
        .padding(.top, 25)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .overlay(
          Rectangle()
            .inset(by: 0.5)
            .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 1)
        )

        TodoListView(
            section: project.entity,
            todos: project.backlogTodos
        )
        Button("Todo 추가") {
            appendNewTodo(project: project.entity)
        }

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
