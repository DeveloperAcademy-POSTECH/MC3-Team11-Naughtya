//
//  ProjectCardView.swift
//  MacOSCoreFeature
//
//  Created by Greed on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectCardView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    public let project: ProjectModel

    private let cornerRadius: CGFloat = 5
    @State private var showModal = false

    var projectEndDay: Date {
        project.endedAt! // TODO: 기획 확정 후 수정
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if project.isBookmarked == true {
                Image(systemName: "pin.fill")
                    .frame(width: 7.5, height: 9)
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                    .onTapGesture {
                        toggleIsBookmarked()
                    }
                    .offset(x: 10, y: 5)
                    .zIndex(1)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(project.category)
                        .font(
                            Font.custom("SF Pro", size: 18)
                                .weight(.medium)
                        )
                        .foregroundColor(.white)
                    Text("- \(changeDateFormat())")
                        .font(
                            Font.custom("SF Pro", size: 10)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                }
                Spacer()
                VStack {
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Text("\(project.completedTodos.count)")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 18)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                        Text("/\(project.todos.count)")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 12)
                                    .weight(.regular)
                            )
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                }
            }
            .zIndex(0)
            .frame(height: 56)
            .padding(.leading, 25)
            .padding(.trailing, 15)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(project.isSelected ? Color(red: 0.12, green: 0.12, blue: 0.12) : Color(red: 0.16, green: 0.16, blue: 0.16))
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
                Button(role: .destructive) {
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
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)
        return formattedDate
    }

}
