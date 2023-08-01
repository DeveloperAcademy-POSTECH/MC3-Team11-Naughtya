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
        VStack(spacing: 0) {
            dateHeader
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
            HStack(alignment: .center, spacing: 2) {
                buildDateButton(imageName: "triangle_left") {
                    viewModel.gotoOneDayBefore()
                }
                Text(viewModel.dateTitle)
                    .foregroundColor(Color.customGray1)
                    .font(.appleSDGothicNeo(size: 32, weight: .semibold).monospacedDigit())
                    .frame(height: 23)
                    .onTapGesture {
                        isPopoverVisible = true
                    }
                    .popover(isPresented: $isPopoverVisible) {
                        calendarPopup
                    }
                buildDateButton(imageName: "triangle_right") {
                    viewModel.gotoOneDayAfter()
                }
            }
            HStack(alignment: .center, spacing: 10) {
                buildCountLabel(
                    title: "전체 할 일",
                    count: viewModel.dailyTodoList?.allTodosCount ?? 0
                )
                buildCountLabel(
                    title: "남은 할 일",
                    count: viewModel.dailyTodoList?.incompletedTodosCount ?? 0
                )
            }
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
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

    private func buildDateButton(
        imageName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            MacOSCoreFeatureImages(name: imageName).swiftUIImage
        }
        .buttonStyle(.borderless)
        .frame(
            width: 22,
            height: 22
        )
    }

    private func buildCountLabel(
        title: String,
        count: Int
    ) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.appleSDGothicNeo(size: 12, weight: .medium))
                .foregroundColor(.customGray1)
            Text(String(viewModel.dailyTodoList?.incompletedTodosCount ?? 0))
                .font(.appleSDGothicNeo(size: 20, weight: .medium))
                .foregroundColor(.pointColor)
        }
        .padding(.horizontal, 10)
        .frame(height: 26)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.customGray7)
        )
    }
}

struct DailyTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTodoListView()
    }
}
