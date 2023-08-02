import SwiftUI
import MacOSCoreFeature

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationSplitView {
            sidebarView
        } detail: {
            if !viewModel.isResultTab {
                mainView
            } else {
                resultView
            }
        }
        .overlay(alignment: .top) {
            Color.black
                .frame(height: 1)
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

    private var sidebarView: some View {
        buildView(backgroundColor: .customGray7) {
            if !viewModel.isResultTab {
                ProjectListView(projects: viewModel.sortedProjects)
            } else {
                ProjectResultListView(
                    projectResults: viewModel.sortedProjectResults,
                    selectedProjectResult: viewModel.selectedProjectResult,
                    projectResultSelector: viewModel
                )
            }
        }
        .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
    }

    private var mainView: some View {
        NavigationStack {
            NavigationView {
                projectTodoListView
                dailyTodoListView
            }
        }
    }

    private var projectTodoListView: some View {
        buildView(backgroundColor: .customGray9) {
            ScrollView {
                ProjectTodoListView(projects: viewModel.selectedProjects)
            }
        }
        .frame(minWidth: 462, minHeight: 756)
    }

    private var dailyTodoListView: some View {
        buildView(backgroundColor: .customGray9) {
            ScrollView {
                DailyTodoListView()
            }
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

    private var resultView: some View {
        buildView(backgroundColor: .customGray9) {
            if let projectResult = viewModel.selectedProjectResult {
                ResultView(projectResult: projectResult)
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

    private func buildView<Content: View>(
        backgroundColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack {
            backgroundColor
            content()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
