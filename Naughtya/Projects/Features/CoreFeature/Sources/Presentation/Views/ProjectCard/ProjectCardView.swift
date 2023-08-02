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
    @State private var gradientPosition: Double = 0.0
    @State private var isAnimating = true
    private let cardViewUserDefaultsKey: String // 각 카드 뷰의 UserDefaults 키
    @State private var hasAppeared = false

    init(project: ProjectModel,
         isDummy: Bool = false,
         dragDropDelegate: DragDropDelegate = DragDropManager.shared) {
        self.project = project
        self.isDummy = isDummy
        self.dragDropDelegate = dragDropDelegate
        // 각 카드 뷰의 UserDefaults 키는 프로젝트 ID를 기반으로 생성합니다.
        self.cardViewUserDefaultsKey = "ProjectCardView_\(project.id)"
        // 해당 카드 뷰의 애니메이션 상태를 UserDefaults에서 로드합니다.
        self._hasAppeared = State(initialValue: UserDefaults.standard.bool(forKey: cardViewUserDefaultsKey))
    }

    var body: some View {
        GeometryReader { geometry in
            let absoluteRect = geometry.frame(in: .global)
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(project.isSelected ? Color.customGray5 : Color.customGray7)
                if !hasAppeared {
                    LinearGradient(
                        gradient: Gradient(colors: [.pointColor, .pointColor]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                AngularGradient(
                                    gradient: Gradient(colors: [.clear, .pointColor, .clear]),
                                    center: .center,
                                    angle: .degrees(gradientPosition)
                                )
                            )
                    )
                    .opacity(isAnimating ? 1 : 0) // 애니메이션 중에만 보이도록 투명도 조절
                    .onAppear {
                        withAnimation(.easeOut(duration: 2)) {
                            gradientPosition = 360 * 2 // 360도 회전 (한 바퀴)
                            isAnimating = false
                        }
                        if !hasAppeared {
                            // 해당 카드 뷰의 애니메이션 상태를 UserDefaults에 저장합니다.
                            UserDefaults.standard.set(true, forKey: cardViewUserDefaultsKey)
                        }
                    }
                }
                RoundedRectangle(cornerRadius: 5)
                    .fill(project.isSelected ? Color.customGray5 : Color.customGray7)
                    .frame(width: geometry.size.width - 4, height: geometry.size.height - 4)
                ZStack(alignment: .trailing) {
                    HStack {
                        contentView
                        Spacer()
                    }
                    VStack(alignment: .trailing, spacing: 0) {
                        bookmarkIndicator
                            .offset(y: -3)
                        todosCountView
                    }
                }
                .padding(.top, 17)
                .padding(.bottom, 15)
                .padding(.leading, 25)
                .padding(.trailing, 20)
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
        VStack(alignment: .leading, spacing: 9) {
            Text("\(Date().dDayCalculater(projectEndDay: projectEndDay))")
                .font(.appleSDGothicNeo(size: 14, weight: .semibold).monospacedDigit())
                .foregroundColor(Color.customGray1)
                .frame(height: 10)
            Text(project.category)
                .font(.appleSDGothicNeo(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(height: 17)
        }
    }

    private var todosCountView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(project.completedTodos.count)")
                .font(.appleSDGothicNeo(size: 24, weight: .semibold).monospacedDigit())
                .foregroundColor(.white)
            Text("/\(project.todos.count)")
                .font(.appleSDGothicNeo(size: 16).monospacedDigit())
                .foregroundColor(.customGray2)
        }
        .frame(height: 17)
    }

    private var bookmarkIndicator: some View {
        Image(systemName: project.isBookmarked ? "star.fill" : "star")
            .font(.appleSDGothicNeo(size: 15))
            .foregroundColor(project.isBookmarked ? .pointColor : .customGray2)
            .onTapGesture {
                toggleBookmarked()
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
                    try await Self.projectUseCase.toggleBookmarked(
                        project.entity,
                        isBookmarked: !project.isBookmarked
                    )
                }
            } label: {
                Label("즐겨찾기", systemImage: "star.fill")
                    .font(.appleSDGothicNeo(size: 12))
                    .labelStyle(.titleAndIcon)
            }
            Button {
                showModal = true
            } label: {
                Label("수정하기", systemImage: "square.and.pencil")
                    .font(.appleSDGothicNeo(size: 12))
                    .labelStyle(.titleAndIcon)
            }
            Divider()
            Button {
                Task {
                    try await Self.projectUseCase.delete(project.entity)
                }
            } label: {
                Label("삭제하기", systemImage: "x.square")
                    .font(.appleSDGothicNeo(size: 12))
                    .labelStyle(.titleAndIcon)
            }
        }
    }

    private var projectEndDay: Date {
        project.endedAt!
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

    private func toggleBookmarked() {
        Task {
            try await Self.projectUseCase.toggleBookmarked(
                project.entity,
                isBookmarked: !project.isBookmarked
            )
        }
    }

    private func changeDateFormat(projectEndDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: projectEndDay)
        return formattedDate
    }
}
