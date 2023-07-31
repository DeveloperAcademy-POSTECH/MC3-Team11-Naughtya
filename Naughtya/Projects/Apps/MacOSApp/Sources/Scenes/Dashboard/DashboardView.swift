import SwiftUI
import MacOSCoreFeature

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationSplitView {
            projectListView
                .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
        } detail: {
            if viewModel.isResultTab {
                if let projectResult = viewModel.selectedProjectResult {
                    ResultView(projectResult: projectResult)
                }
            } else {
                defaultView
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                tabPicker
            }
        }
    }

    private var defaultView: some View {
        NavigationStack {
            NavigationView {
                projectTodoListView
                dailyTodoListView
                    .frame(minWidth: 424)
            }
        }
    }

    private var projectListView: some View {
        ProjectListView(
            projects: viewModel.projectsInSidebar,
            projectSelector: viewModel.isResultTab ? viewModel : nil
        )
    }

    private var projectTodoListView: some View {
        List {
            ProjectTodoListView(projects: viewModel.selectedProjectsInProgress)
        }
        .frame(minWidth: 462, minHeight: 756)
        .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900)
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
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
        Picker(selection: $viewModel.selectedTabIndex, label: Text("")) {
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
