import SwiftUI
import MacOSCoreFeature

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationSplitView {
            projectListView
        } content: {
            if !viewModel.isResultTab {
                projectTodoListView
            }
        } detail: {
            if viewModel.isResultTab {
                if let projectResult = viewModel.selectedProjectResult {
                    ResultView(projectResult: projectResult)
                }
            } else {
                dailyTodoListView
            }
        }
        .navigationTitle("")
        .toolbarBackground(
            Color.customGray7,
            for: .automatic
        )
        .toolbar {
            ToolbarItem(placement: .navigation) {
                tabPicker
            }
        }
    }

    private var projectListView: some View {
        ZStack {
            Color.customGray7
            ProjectListView(
                projects: viewModel.projectsInSidebar,
                projectSelector: viewModel.isResultTab ? viewModel : nil
            )
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
    }

    private var projectTodoListView: some View {
        ZStack {
            Color.customGray9
            ScrollView {
                ProjectTodoListView(projects: viewModel.selectedProjectsInProgress)
                    .padding(.horizontal, 20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                FilterButton()
            }
        }
    }

    private var dailyTodoListView: some View {
        ZStack {
            Color.customGray9
            ScrollView {
                DailyTodoListView()
                    .padding(.horizontal, 20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .frame(minWidth: 462, minHeight: 756)
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
        Picker(
            selection: $viewModel.selectedTabIndex,
            label: Text("")
        ) {
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
