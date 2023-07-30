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

    let project: ProjectModel
    let isDummy: Bool
    let dragDropDelegate: DragDropDelegate
    @State private var absoluteRect: CGRect!
    @State private var isBeingDragged = false
    @State private var showModal = false
    var projectEndday: Date {
        project.endedAt!
    }

    init(project: ProjectModel,
         isDummy: Bool = false,
         dragDropDelegate: DragDropDelegate = DragDropManager.shared) {
        self.project = project
        self.isDummy = isDummy
        self.dragDropDelegate = dragDropDelegate
    }

    var body: some View {
        GeometryReader { geometry in
            let absoluteRect = geometry.frame(in: .global)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(project.isSelected ? Color.customGray4 : Color.customGray8)
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        contentView
                            .padding(0)
                        Spacer()
                        VStack(alignment: .trailing) {
                            bookmarkIndicator
                            todosCountView
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .padding(.leading, 25)
                    .padding(.trailing, 15)
                    .padding(.top, 17)
                    .padding(.bottom, 15)
                }
                .frame(height: 68)
            }
            .onAppear {
                registerAbsoluteRect(absoluteRect)
            }
            .onChange(of: absoluteRect) {
                guard !(isBeingDragged || isDummy) else {
                    return
                }
                registerAbsoluteRect($0)
            }
            .onChange(of: isBeingDragged) {
                guard !$0 else {
                    return
                }
                registerAbsoluteRect(absoluteRect)
            }
        }
        .opacity(isDummy || isBeingDragged ? 0.5 : 1)
        .gesture(dragGesture)
        .contextMenu {
            contextMenu
        }
        .onTapGesture {
            Task {
                try await Self.projectUseCase.toggleSelected(
                    project.entity,
                    isSelected: !project.isSelected
                )
            }
        }
        .onDisappear {
            dragDropDelegate.unregisterAbsoluteRect(dragDropableHash)
        }
        .sheet(isPresented: $showModal) {
            ProjectSetModalView(project: project)
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("\(Date().dDayCalculater(projectEndDay: projectEndday))")
              .font(Font.custom("Apple SD Gothic Neo", size: 12).weight(.semibold)
              )
              .foregroundColor(Color.customGray1)
            Text(project.category)
                .font(Font.custom("Apple SD Gothic Neo", size: 24).weight(.semibold))
                .foregroundColor(.white)
        }
    }

    private var todosCountView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(project.completedTodos.count)")
                .font(Font.custom("Apple SD Gothic Neo", size: 24).weight(.semibold))
                .foregroundColor(.white)
            Text("/\(project.todos.count)")
                .font(Font.custom("Apple SD Gothic Neo", size: 16).weight(.regular))
                .foregroundColor(.customGray2)
        }
    }

    private var bookmarkIndicator: some View {
        Image(systemName: project.isBookmarked ? "star.fill" : "star")
            .font(Font.custom("SF Pro", size: 15))
            .foregroundColor(project.isBookmarked ? .pointColor : .customGray2)
            .onTapGesture {
                toggleIsBookmarked()
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                let itemLocation = absoluteRect.origin + $0.location - $0.startLocation
                if !isBeingDragged {
                    dragDropDelegate.startToDrag(
                        project.entity,
                        size: absoluteRect.size,
                        itemLocation: itemLocation
                    )
                } else {
                    dragDropDelegate.drag(
                        project.entity,
                        itemLocation: itemLocation
                    )
                }
                isBeingDragged = true
            }
            .onEnded {
                dragDropDelegate.drop(
                    project.entity,
                    touchLocation: absoluteRect.origin + $0.location
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBeingDragged = false
                }
            }
    }

    private var contextMenu: some View {
        VStack {
            Button {
                Task {
                    try await Self.projectUseCase.toggleIsBookmarked(
                        project.entity,
                        isBookmarked: !project.isBookmarked
                    )
                }
            } label: {
                Label("즐겨찾기", systemImage: "star.fill")
                    .font(Font.custom("SF Pro", size: 12))
                    .labelStyle(.titleAndIcon)
            }
            Button {
                showModal = true
            } label: {
                Label("수정하기", systemImage: "pencil.circle")
                    .font(Font.custom("SF Pro", size: 12))
                    .labelStyle(.titleAndIcon)
            }
            Divider()
            Button {
                Task {
                    try await Self.projectUseCase.delete(project.entity)
                }
            } label: {
                Label("삭제하기", systemImage: "x.circle")
                    .font(Font.custom("SF Pro", size: 12))
                    .labelStyle(.titleAndIcon)
            }
        }
    }

    private var dragDropableHash: DragDropableHash {
        DragDropableHash(
            item: project.entity,
            priority: 1
        )
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            dragDropableHash,
            rect: rect
        )
    }

    private func toggleIsBookmarked() {
        Task {
            try await Self.projectUseCase.toggleIsBookmarked(
                project.entity,
                isBookmarked: !project.isBookmarked)
        }
    }

    private func changeDateFormat(projectEndDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)
        return formattedDate
    }
}
