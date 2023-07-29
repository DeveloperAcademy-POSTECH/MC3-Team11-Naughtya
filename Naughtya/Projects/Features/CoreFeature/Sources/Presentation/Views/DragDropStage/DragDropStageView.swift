//
//  DragDropStageView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct DragDropStageView: View {
    @StateObject private var dragDropManager = DragDropManager.shared

    private let topPadding: CGFloat

    public init(topPadding: CGFloat = 0) {
        self.topPadding = topPadding
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            emptyView
            if let dragged = dragDropManager.dragged {
                VStack {
                    switch dragged.item {
                    case let project as ProjectEntity:
                        ProjectCardView(
                            project: .from(entity: project),
                            isDummy: true
                        )
                    case let todo as TodoEntity:
                        TodoItemView(
                            todo: .from(entity: todo),
                            isDummy: true
                        )
                    default:
                        EmptyView()
                    }
                }
                .offset(
                    x: dragged.location.x,
                    y: dragged.location.y - dragged.size.height / 2 - topPadding / 2
                )
                .frame(
                    width: dragged.size.width,
                    height: dragged.size.height
                )
            }
        }
    }

    private var emptyView: some View {
        Rectangle()
            .opacity(0)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
    }
}

struct DragDropStageView_Previews: PreviewProvider {
    static var previews: some View {
        DragDropStageView()
    }
}
