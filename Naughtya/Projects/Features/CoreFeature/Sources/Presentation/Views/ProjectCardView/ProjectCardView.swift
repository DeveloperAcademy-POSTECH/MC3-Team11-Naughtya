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

    private let cornerRadius: CGFloat = 5
    @State private var showModal = false

    var projectEndDay: Date? {
        project.endedAt
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if project.isBookmarked == true {
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
            HStack {
                VStack(alignment: .leading) {
                    Text(project.category)
                    .font(
                    Font.custom("Apple SD Gothic Neo", size: 24)
                    .weight(.medium)
                    )
                        .foregroundColor(.white)
                    if let projectEndDay = projectEndDay {
                        Text("- \(changeDateFormat(projectEndDay: projectEndDay))")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 12)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color.customGray2)
                    }
                }
                Spacer()
                VStack {
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Text("\(project.completedTodos.count)")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 24)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color.pointColor)
                        Text("/\(project.todos.count)")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 16)
                                    .weight(.regular)
                            )
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                }
            }
            .zIndex(0)
            .frame(height: 68)
            .padding(.leading, 25)
            .padding(.trailing, 15)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(project.isSelected ? Color.customGray4 : Color.white.opacity(0.001))
            )
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
                    self.showModal = true
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
            .sheet(isPresented: self.$showModal) {
                ProjectSetModalView(project: project)
            }
        }
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
