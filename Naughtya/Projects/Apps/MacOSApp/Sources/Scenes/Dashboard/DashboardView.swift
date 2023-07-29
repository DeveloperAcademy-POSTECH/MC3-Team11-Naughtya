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
        } detail: {
            switch selectedTabIndex {
            case 0:
                NavigationStack {
                    NavigationView {
                        projectTodoListView
                            .frame(minWidth: 424)
                        dailyTodoListView
                            .frame(minWidth: 424)
                    }
                }
            default: ProjectResultListView()
            }

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
        .frame(minWidth: 462, minHeight: 756)
        .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900)
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
            Image(systemName: "house")
                .tag(0)
            Image(systemName: "list.bullet")
                .tag(1)
        }
        .pickerStyle(.segmented)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
