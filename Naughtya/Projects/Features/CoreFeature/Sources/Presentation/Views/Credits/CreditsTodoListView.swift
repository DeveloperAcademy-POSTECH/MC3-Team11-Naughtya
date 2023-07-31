//
//  CreditsTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct CreditsTodoListView: View {
    let projectResult: ProjectResultModel

    init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    var body: some View {
        VStack {
            let dateStrings = projectResult.dateStringCompletedTodosMap.map { $0.key }.sorted()
            ForEach(dateStrings, id: \.self) { dateString in
                HStack(alignment: .top) {
                    Text(dateString)
                    VStack {
                        let todos = projectResult.dateStringCompletedTodosMap[dateString] ?? []
                        ForEach(todos) { todo in
                            Text(todo.title.value)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

struct CreditsTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsTodoListView(projectResult: .from(entity: .sample))
    }
}
