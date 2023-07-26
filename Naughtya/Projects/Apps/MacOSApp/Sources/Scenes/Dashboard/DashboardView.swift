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
                .navigationSplitViewColumnWidth(min: 190, ideal: 250, max: 298)
        } content: {
                ProjectTodoListView(projects: viewModel.projects)
                .navigationSplitViewColumnWidth(min: 460, ideal: 520, max: 757)
                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
        } detail: {
                DailyTodoListView()
            .navigationSplitViewColumnWidth(min: 524, ideal: 550, max: 757)
            //            CombinedTodoListView()
            //            HStack {
            //                List {
            //                    ProjectTodoListView(projects: viewModel.projects)
            //                        .frame(minWidth: 460, maxWidth: 607, alignment: .top)
            //                }
            //                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
            //                List {
            //                    DailyTodoListView()
            //                        .frame(minWidth: 524, maxWidth: 607, alignment: .top)
            //                }
            //            }
        }
        .navigationTitle("")
        .navigationSplitViewStyle(.balanced)
        .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                TopBarView()
            }
            ToolbarItemGroup(placement: .navigation) {
                HStack(spacing: 0) {
                    Button {
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    Button {
                        //                ProjectResultListView()
                    } label: {
                        Image(systemName: "books.vertical")
                    }
                    
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
