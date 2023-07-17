//
//  DashboardView.swift
//  IOSApp
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import IOSCoreFeature

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Daily")
                ScrollView {
                    TodoListView(todos: viewModel.dailyTodos)
                }
            }
            VStack(alignment: .leading) {
                Text("Projects")
                ScrollView {
                    ProjectListView(projects: viewModel.projects)
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
