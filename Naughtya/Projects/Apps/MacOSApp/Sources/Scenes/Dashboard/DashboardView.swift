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
        NavigationSplitView {
            ProjectListView(projects: viewModel.projects)
                .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
        } content: {
            List {
                ProjectTodoListView(projects: viewModel.projects)
            }
            .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900).toolbar {
            }

        } detail: {
            List {
                DailyTodoListView()
            }
            .navigationSplitViewColumnWidth(min: 424, ideal: 524, max: 900)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {

                } label: {
                    Image(systemName: "list.bullet")
                }
            }

            ToolbarItemGroup(placement: .navigation) {
                HStack(spacing: 0) {
                    Button {
                    } label: {
                        Image(systemName: "folder")
                    }
                    Button {
                        //                ProjectResultListView()
                    } label: {
                        Image(systemName: "books.vertical")
                    }
                }
            }

            ToolbarItemGroup(placement: .primaryAction) {
                    TopBarView()
            }
        }
        .onAppear {
            Task {
                try await CloudKitManager.shared.syncWithStores()
            }
        }
    }
}

    struct DashboardView_Previews: PreviewProvider {
        static var previews: some View {
            DashboardView()
        }
    }
