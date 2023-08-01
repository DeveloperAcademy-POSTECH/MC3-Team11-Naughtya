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
        HStack {
            VStack(alignment: .leading, spacing: 9) {
                Text(project.category)
                    .lineLimit(1)
                    .font(.system(size: 32).weight(.semibold))
                    .foregroundColor(.customGray1)
                    .frame(height: 23)
                if let startedAt = project.startedAt?.getDateString("yyyy.MM.dd"),
                   let endedAt = project.endedAt?.getDateString("yyyy.MM.dd") {
                    Text("\(startedAt) -\(endedAt)")
                        .font(.system(size: 16))
                        .foregroundColor(Color.customGray3)
                        .frame(height: 11)
                }
                Group {
                    if let goals = project.goals,
                       !goals.isEmpty {
                        Text("# \(goals)")
                    } else {
                        Text("# \(project.category) 할 일 완료해서 에필로그 기록하기")
                    }
                }
                .foregroundColor(.customGray2)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .frame(height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.customGray8)
                )
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            Spacer()
        }
        .padding(.horizontal, 20)
        VStack {
            TodoListView(
                section: project.entity,
                todos: todos,
                isBlockedToEdit: filterManager.isSearching
            )
            HStack(alignment: .center, spacing: 4) {
                Text("􀅼")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                Text("여기를 클릭해서 할 일을 추가해요.")
                    .font(.system(size: 14))
                    .frame(height: 16, alignment: .leading)
            }
            .foregroundColor(isHovered ? Color.pointColor : Color.customGray2)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.0001))
                    .frame(minWidth: 1000, alignment: .leading)
            )
//            .padding(.top, 100)
            .padding(.leading, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                appendNewTodo(project: project.entity)
            }
            .onHover { hovered in
                isHovered = hovered
            }
            Spacer().frame(height: 70)
        }
    }

    private var todos: [TodoModel] {
        var todos = project.backlogTodos
        switch filterManager.filter {
        case .incompleted:
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
