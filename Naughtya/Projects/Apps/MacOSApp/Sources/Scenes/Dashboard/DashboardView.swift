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
        ZStack {
            VStack(spacing: 0) {
                TopBarView()
                    .zIndex(1)
                HStack(alignment: .top) {
                    List {
                        ProjectSummaryListView(projects: viewModel.projects)
                    }
                    List {
                        ProjectTodoListView(projects: viewModel.projects)
                    }
                    List {
                        DailyTodoListView()
                    }
                }
                .zIndex(0)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
