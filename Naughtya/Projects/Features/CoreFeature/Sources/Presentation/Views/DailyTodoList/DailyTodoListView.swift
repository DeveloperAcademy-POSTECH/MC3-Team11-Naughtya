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
    @State private var todoDate = Date()
    @State private var isPopoverVisible = false
    @State var dateForPicker = Date()

    public init() {
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 6) {
            VStack(alignment: .center) {
                dateHeader
            }
            .padding(.horizontal, 40)
            .padding(.top, 50)
            .padding(.bottom, 41)
            .frame(alignment: .top)
            if let dailyTodoList = viewModel.dailyTodoList {
                TodoListView(
                    section: dailyTodoList.entity,
                    todos: dailyTodoList.todos
                )
            }
        }
        .onAppear {
            viewModel.fetchTodayIfNeeded()
        }
        .onChange(of: dateForPicker) {
            viewModel.gotoDate($0)
        }
    }

    private var dateHeader: some View {
        VStack(alignment: .center, spacing: 17) {
            HStack {
                Button {
                    viewModel.gotoOneDayBefore()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.customGray2)
                }
                .frame(width: 20, height: 23)
                .buttonStyle(.borderless)
                if !viewModel.isTodayFetched {
                    Button("Today") {
                        viewModel.fetchTodayIfNeeded()
                    }
                    .buttonStyle(.borderless)
                } else {
                    Text(viewModel.dateTitle)
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 32)
                                .weight(.semibold)
                        )
                        .foregroundColor(Color.customGray1)
                        .frame(width: 170, height: 25)
                        .onTapGesture {
                            isPopoverVisible = true
                        }
                        .popover(isPresented: $isPopoverVisible) {
                            calendarPopup
                        }

                }
                Button {
                    viewModel.gotoOneDayAfter()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.customGray2)
                }
                .frame(width: 20, height: 23)
                .buttonStyle(.borderless)
            }
            HStack(alignment: .top, spacing: 9) {
                HStack(alignment: .center, spacing: 10) {
                    Text("전체 할 일")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 12)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.customGray1)
                        .frame(width: 48, height: 8, alignment: .center)
                    Text(String(viewModel.dailyTodoList?.allTodosCount ?? 0))
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 20)
                                .weight(.medium)
                        )
                        .foregroundColor(Color.pointColor)
                }
                .frame(width: 91.5, height: 26, alignment: .center)
                .background(Color.customGray7)
                .cornerRadius(5)
                HStack(alignment: .center, spacing: 10) {
                    Text("남은 할 일")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 12)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.customGray1)
                        .frame(width: 48, height: 8, alignment: .center)
                    Text(String(viewModel.dailyTodoList?.incompletedTodosCount ?? 0))
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 20)
                                .weight(.medium)
                        )
                        .foregroundColor(Color.pointColor)
                }
                .frame(width: 91.5, height: 26, alignment: .center)
                .background(Color.customGray7)
                .cornerRadius(5)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(height: 62)
        .padding(0)
    }

    private var calendarPopup: some View {
        VStack {
            DatePicker(
                "",
                selection: $dateForPicker,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
        }
        .frame(width: 150, height: 170)
    }
}

struct DailyTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTodoListView()
    }
}
