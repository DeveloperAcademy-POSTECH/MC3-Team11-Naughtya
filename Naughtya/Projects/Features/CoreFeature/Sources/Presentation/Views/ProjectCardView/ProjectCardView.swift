//
//  ProjectCardView.swift
//  MacOSCoreFeature
//
//  Created by Greed on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectCardView: View {
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()

    public let project: ProjectModel
    @State private var showModal = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                contentView
                Spacer()
                todosCountView
            }
            .frame(height: 68)
            .padding(.leading, 25)
            .padding(.trailing, 15)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(project.isSelected ? Color.customGray4 : Color.white.opacity(0.001))
            )
            if project.isBookmarked {
                bookmarkIndicator
            }
        }
        .onTapGesture {
            Task {
                try await Self.projectUseCase.toggleSelected(
                    project.entity,
                    isSelected: !project.isSelected
                )
            }
        }
        .contextMenu {
            Button {
                showModal = true
            } label: {
                Label("Modify", systemImage: "pencil")
                    .labelStyle(.titleAndIcon)
            }
            Button {
                Task {
                    try await Self.projectUseCase.toggleIsBookmarked(
                        project.entity,
                        isBookmarked: !project.isBookmarked)
                }
            } label: {
                Label("Bookmark", systemImage: "bookmark")
                    .labelStyle(.titleAndIcon)
            }
            Divider()
            Button {
                Task {
                    try await Self.projectUseCase.delete(project.entity)
                }
            } label: {
                Label("삭제", systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            }
        }
        .sheet(isPresented: $showModal) {
            ProjectSetModalView(project: project)
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading) {
            Text(project.category)
                .font(Font.custom("SF Pro", size: 24).weight(.medium))
                .foregroundColor(.white)
            if let projectEndDay = project.endedAt {
                Text("- \(changeDateFormat(projectEndDay: projectEndDay))")
                    .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                    .foregroundColor(Color.customGray2)
            }
        }
    }

    private var todosCountView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(project.completedTodos.count)")
                .font(Font.custom("SF Pro", size: 24).weight(.semibold))
                .foregroundColor(Color.pointColor)
            Text("/\(project.todos.count)")
                .font(Font.custom("SF Pro", size: 16).weight(.regular))
                .foregroundColor(.white)
        }
        .multilineTextAlignment(.trailing)
    }

    private var bookmarkIndicator: some View {
        Image(systemName: "pin.fill")
            .rotationEffect(.degrees(30))
            .font(.system(size: 9))
            .foregroundColor(.pointColor)
            .onTapGesture {
                toggleIsBookmarked()
            }
            .offset(x: 12, y: 16)
            .zIndex(1)
    }

    func toggleIsBookmarked() {
        Task {
            try await Self.projectUseCase.toggleIsBookmarked(
                project.entity,
                isBookmarked: !project.isBookmarked)
        }
    }

    func changeDateFormat(projectEndDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)
        return formattedDate
    }
}
