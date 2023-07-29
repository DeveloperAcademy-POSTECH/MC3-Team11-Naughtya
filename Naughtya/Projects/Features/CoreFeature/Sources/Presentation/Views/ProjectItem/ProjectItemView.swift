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

    public let project: ProjectModel
    @ObservedObject private var filterManager = FilterManager.shared

    @State private var isHovered: Bool = false

    public init(project: ProjectModel) {
        self.project = project
    }

    public var body: some View {
        //        VStack(alignment: .leading, spacing: 9) {
        //            Text(project.category)
        //                .lineLimit(1)
        //                .font(
        //                    Font.custom("Apple SD Gothic Neo", size: 32)
        //                        .weight(.bold)
        //                )
        //                .foregroundColor(Color.customGray1)
        //            HStack(spacing: 0) {
        //                Text("2023.07.29")
        //                    .font(Font.custom("Apple SD Gothic Neo", size: 16))
        //                    .foregroundColor(Color.customGray3)
        //                Text("-")
        //                    .font(Font.custom("Apple SD Gothic Neo", size: 16))
        //                    .foregroundColor(Color.customGray3)
        //                Text("2023.08.15")
        //                    .font(Font.custom("Apple SD Gothic Neo", size: 16))
        //                    .foregroundColor(Color.customGray3)
        //            }
        //            HStack(spacing: 10) {
        //                Text("#")
        //                if let goals = project.goals,
        //                   !goals.isEmpty {
        //                    Text(goals)
        //                } else {
        //                    Text("(선택) 목표를 입력해 보세요.")
        //                }
        //            }
        //            .font(Font.custom("Apple SD Gothic Neo", size: 14))
        //            .foregroundColor(Color.customGray2)
        //            .frame(height: 26)
        //            .padding(.horizontal, 10)
        //            .background(Color.customGray8)
        //            .cornerRadius(5)
        //        }
        //        .padding(.horizontal, 40)
        //        .padding(.top, 40)
        //        .padding(.bottom, 20)
        //        .frame(width: 690, alignment: .topLeading)
        //        .overlay(
        //            Rectangle()
        //                .inset(by: 1.5)
        //                .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 3)
        //        )

        // MARK: - 아래코드로 하면 정상, 위의 코드로 하면 이상한 ui
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(project.category)
                    .foregroundColor(.white)
                    .font(.custom("SF Pro", size: 32).weight(.bold))
                    .lineLimit(1)
                    .frame(height: 35)
                HStack {
                    if let goals = project.goals,
                       !goals.isEmpty {
                        Text(goals)
                    } else {
                        Text("(선택) 목표를 입력해 보세요.")
                    }
                }// HStack
                .foregroundColor(Color.customGray2)
                .font(.custom("SF Pro", size: 20))
                .frame(minHeight: 32)
            }// Vstack
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)
        VStack {
            TodoListView(
                section: project.entity,
                todos: todos,
                isBlockedToEdit: filterManager.isSearching
            )
            HStack(alignment: .center, spacing: 4) {
                Text("􀅼")
                    .font(Font.custom("SF Pro", size: 22).weight(.light))
                Text("프로젝트 할 일을 추가해보세요.")
                    .font(Font.custom("Apple SD Gothic Neo", size: 14))
                    .frame(width: 184, height: 16, alignment: .leading)
            }
            .foregroundColor(isHovered ? Color.pointColor : Color.customGray2)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.0001))
                    .frame(minWidth: 1000, alignment: .leading)
            )
            .padding(.top, -100)
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture {
                appendNewTodo(project: project.entity)
            }
            .onHover { hovered in
                isHovered = hovered
            }
        }
    }

    private var todos: [TodoModel] {
        var todos = project.backlogTodos
        switch filterManager.filter {
        case .uncompleted:
            todos = todos
                .filter { !$0.isCompleted }
        case .completed:
            todos = todos
                .filter { $0.isCompleted }
        default:
            break
        }
        if filterManager.isSearching {
            todos = todos
                .filter { $0.title.contains(filterManager.searchedText) }
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
