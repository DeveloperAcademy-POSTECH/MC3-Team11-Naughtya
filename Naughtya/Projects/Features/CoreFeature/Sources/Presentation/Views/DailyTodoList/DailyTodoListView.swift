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
        VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Daily To Do")
                        .font(
                            Font.custom("SF Pro", size: 24)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                    dateHeader
                }
                .frame(width: 300, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer().frame(height: 20)
            if let dailyTodoList = viewModel.dailyTodoList {
                TodoListView(
                    section: dailyTodoList.entity,
                    todos: dailyTodoList.todos
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onAppear {
            viewModel.fetchTodayIfNeeded()
        }
    }

    private var dateHeader: some View {
        HStack {
            Button {
                viewModel.gotoOneDayBefore()
            } label: {
                Image(systemName: "arrowtriangle.backward.fill")
                    .foregroundColor(Color(red: 0.72, green: 0.72, blue: 0.72))
            }
            .buttonStyle(.borderless)
            if !viewModel.isTodayFetched {
                Button("Today") {
                    viewModel.fetchTodayIfNeeded()
                }
                .buttonStyle(.borderless)
            } else {
                Text(viewModel.dateTitle)
                  .font(Font.custom("SF Pro", size: 14))
                  .foregroundColor(Color(red: 0.72, green: 0.72, blue: 0.72))
            }
            Button {
                viewModel.gotoOneDayAfter()
            } label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(Color(red: 0.72, green: 0.72, blue: 0.72))
            }
            .buttonStyle(.borderless)
        }
    }
}

struct DailyTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTodoListView()
    }
}
