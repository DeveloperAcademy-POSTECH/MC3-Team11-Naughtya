//
//  DailyTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct DailyTodoListView: View {
    @StateObject private var viewModel = DailyTodoListViewModel()

    public init() {
    }

    public var body: some View {
        VStack {
            VStack {
                Text("Daily To do")
                HStack {
                    dateHeader
                    Spacer()
                }
            }
            TodoListView(todos: viewModel.todos)
        }
        .onAppear {
            viewModel.fetchToday()
        }
    }

    private var dateHeader: some View {
        HStack {
            Button("Prev") {
                viewModel.gotoOneDayBefore()
            }
            Text(viewModel.dateTitle)
            Button("Next") {
                viewModel.gotoOneDayAfter()
            }
        }
    }
}

struct DailyTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTodoListView()
    }
}
