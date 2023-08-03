//
//  EpilogTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct EpilogTodoListView: View {
    let projectResult: ProjectResultModel

    init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 213) {
            let dateStrings = projectResult.dateStringCompletedTodosMap.map { $0.key }.sorted()
            ForEach(dateStrings, id: \.self) { dateString in
                HStack(alignment: .top, spacing: 79) {
                    Text(dateString)
                        .foregroundColor(.white)
                        .font(.system(size: 32, weight: .medium))
                        .frame(height: 31)
                    VStack(alignment: .leading, spacing: 25) {
                        let todos = projectResult.dateStringCompletedTodosMap[dateString] ?? []
                        ForEach(todos) { todo in
                            buildTodoItemView(title: todo.title.value)
                        }
                    }
                }
                .padding(.bottom)
            }
        }.frame(alignment: .center )
    }

    private func buildTodoItemView(title: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "checkmark.square.fill")
                .foregroundColor(.pointColor)
            Text(title)
                .foregroundColor(.customGray2)
        }
        .font(.system(size: 26))
        .frame(height: 31)
    }
}
