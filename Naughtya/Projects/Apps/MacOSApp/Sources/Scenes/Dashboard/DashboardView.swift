//
//  DashboardView.swift
//  MacOSApp
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import MacOSCoreFeature

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                List {
                    ProjectListView(projects: viewModel.projects)
                }
            }
            VStack(alignment: .leading) {
                Text("Daily")
                    .font(.title)
                List {
                    TodoListView(todos: viewModel.dailyTodos)
                }
            }
            VStack(alignment: .leading) {
                Text("Projects")
                    .font(.title)
                List {
                    ProjectTodoListView(projects: viewModel.projects)
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
