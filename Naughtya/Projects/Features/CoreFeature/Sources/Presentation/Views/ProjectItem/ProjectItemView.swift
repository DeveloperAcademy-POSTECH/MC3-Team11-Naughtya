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
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 9) {
                    Text(project.category)
                        .lineLimit(1)
                        .font(.appleSDGothicNeo(size: 32, weight: .semibold))
                        .foregroundColor(.customGray1)
                        .frame(height: 23)
                    if let startedAt = project.startedAt?.getDateString("yyyy.MM.dd"),
                       let endedAt = project.endedAt?.getDateString("yyyy.MM.dd") {
                        Text("\(startedAt) -\(endedAt)")
                            .font(.appleSDGothicNeo(size: 16))
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
                    .font(.appleSDGothicNeo(size: 14))
                    .padding(.horizontal, 16)
                    .frame(height: 26)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.customGray8)
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 20)
            VStack {
                TodoListView(
                    section: project.entity,
                    todos: todos,
                    isBlockedToEdit: filterManager.isSearching
                )
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .light))
                    Text("프로젝트 할 일을 추가해보세요.")
                        .font(.system(size: 14))
                    Spacer()
                }
                .foregroundColor(isHovered ? Color.pointColor : Color.customGray2)
                .padding(.leading, 18)
                .frame(height: 40)
                .background(.white.opacity(0.001))
                .animation(.easeOut(duration: 0.1), value: isHovered)
                .onTapGesture {
                    appendNewTodo(project: project.entity)
                }
                .onHover { hovered in
                    isHovered = hovered
                }
                Spacer()
                    .frame(height: 70)
            }
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
