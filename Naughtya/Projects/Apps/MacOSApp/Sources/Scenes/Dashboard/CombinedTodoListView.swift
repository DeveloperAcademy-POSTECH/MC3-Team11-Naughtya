//
//  CombinedTodoListView.swift
//  MacOSApp
//
//  Created by Greed on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import MacOSCoreFeature

struct CombinedTodoListView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                List {
                    ProjectTodoListView(projects: viewModel.projects)
                        .navigationSplitViewColumnWidth(min: 460, ideal: 607, max: 607)
                }
            }
            VStack(alignment: .leading) {
                List {
                    DailyTodoListView()
                }
            }
        }
    }
}

struct CombinedTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedTodoListView()
    }
}
