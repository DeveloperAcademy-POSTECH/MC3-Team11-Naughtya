import SwiftUI
import MacOSCoreFeature

struct ResultBoardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedTabIndex = 0
    private let tabs = ["folder", "list.clipboard"]

    var body: some View {
        NavigationSplitView {
            resultSideView
                .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
        } detail: {
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                tabPicker
            }
        }
    }

//    private var projectListView: some View {
//        ProjectListView(projects: viewModel.projectsInSidebar)
//    }
    private var resultSideView: some View {
        ResultSideView(projects: viewModel.projectsInSidebar)
    }

    private var projectTodoListView: some View {
        List {
            ProjectTodoListView(projects: viewModel.selectedProjectsInProgress)
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

struct ResultBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ResultBoardView()
    }
}
