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
    @State private var selectedTabIndex = 0
    private let tabs = ["folder", "list.clipboard"]

    var body: some View {
        NavigationSplitView {
            projectListView
                .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
        } content: {
            projectTodoListView
                .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900)
        } detail: {
            dailyTodoListView
                .navigationSplitViewColumnWidth(min: 424, ideal: 524, max: 900)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                tabPicker
            }
        }
        .onAppear {
            Task {
                try await CloudKitManager.shared.syncWithStores()
            }
        }
    }

    private var projectListView: some View {
        ProjectListView(projects: viewModel.sortedProjects)
    }

    private var projectTodoListView: some View {
        List {
            ProjectTodoListView(projects: viewModel.selectedProjects)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                FilterButton()
            }
        }
    }

    private var dailyTodoListView: some View {
        List {
            DailyTodoListView()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Spacer()
            }
            ToolbarItem(placement: .primaryAction) {
                SearchView()
            }
        }
    }

    private var tabPicker: some View {
        Picker(selection: $selectedTabIndex, label: Text("")) {
            ForEach(tabs, id: \.self) { tab in
                Image(systemName: tab)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
