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
                    Spacer()
                    HStack {
                        contentView
                        Spacer()
                        todosCountView
                    }
                    .padding(.leading, 25)
                    .padding(.trailing, 15)
                    Spacer()
                }
                if project.isBookmarked {
                    bookmarkIndicator
                }
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
        .frame(height: 68)
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
        VStack(alignment: .leading) {
            Text(project.category)
                .font(Font.custom("SF Pro", size: 24).weight(.medium))
                .foregroundColor(.white)
            if let projectEndDay = project.endedAt {
                Text("- \(changeDateFormat(projectEndDay: projectEndDay))")
                    .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                    .foregroundColor(.customGray2)
            }
        }
    }

    private var todosCountView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(project.completedTodos.count)")
                .font(Font.custom("SF Pro", size: 24).weight(.semibold))
                .foregroundColor(.pointColor)
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
                showModal = true
            } label: {
                Label("Modify", systemImage: "pencil")
                    .labelStyle(.titleAndIcon)
            }
            Button {
                Task {
                    try await Self.projectUseCase.toggleIsBookmarked(
                        project.entity,
                        isBookmarked: !project.isBookmarked
                    )
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
