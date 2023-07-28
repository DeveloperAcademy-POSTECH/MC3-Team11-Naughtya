//
//  ProjectItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectItemView: View {
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()
    @State private var selectedSortOption = 0
    private let sortOptions = ["전체보기", "완료 todo", "미완료 todo"]

    public let project: ProjectModel
    @ObservedObject private var searchManager = SearchManager.shared

    public init(project: ProjectModel) {
        self.project = project
    }

    public var body: some View {
        HStack {
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
            .padding(.horizontal, 20)
            .frame(width: 270, alignment: .topLeading)
            Picker(selection: $selectedSortOption, label: Text("")) {
                ForEach(0..<sortOptions.count) { index in
                    Text(sortOptions[index])
                }
            }
            .frame(width: 110)
            .pickerStyle(DefaultPickerStyle())
            .foregroundColor(Color.pointColor)
        }
        .padding(.leading, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)

        VStack {

            TodoListView(
                section: project.entity,
                todos: todos,
                isBlockedToEdit: searchManager.isSearching
            )

            HStack(alignment: .center, spacing: 4) {

                Text("􀅼")
                  .font(
                    Font.custom("SF Pro", size: 22)
                      .weight(.light)
                  )
                  .foregroundColor(Color.customGray3)

                Text("프로젝트 할 일을 추가해보세요.")
                  .font(Font.custom("Apple SD Gothic Neo", size: 14))
                  .foregroundColor(Color.customGray3)
                  .frame(width: 184, height: 16, alignment: .leading)
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.0001))
                    .frame(minWidth: 1000, alignment: .leading)
            )            .padding(.top, -100)
            .frame(maxWidth: .infinity, alignment: .center)

            .onTapGesture {
                appendNewTodo(project: project.entity)
            }

        }

    }

    private var todos: [TodoModel] {
        var todos = project.backlogTodos
        if searchManager.isSearching {
            todos = todos
                .filter { $0.title.contains(searchManager.searchedText) }
        }
        return todos
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
