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

    public init() {
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            emptyView
            if let dragged = dragDropManager.dragged {
                if let todo = dragged.item as? TodoEntity {
                    TodoItemView(
                        todo: .from(entity: todo),
                        isDummy: true
                    )
                    .opacity(0.5)
                    .offset(
                        x: dragged.location.x,
                        y: dragged.location.y - dragged.size.height / 2
                    )
                    .frame(
                        width: dragged.size.width,
                        height: dragged.size.height
                    )
                }
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
