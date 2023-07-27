import SwiftUI
 import MacOSCoreFeature

 struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isSelected = true

    var body: some View {
        NavigationSplitView {
            ProjectListView(projects: viewModel.projects)
                .navigationSplitViewColumnWidth(min: 195, ideal: 250, max: 298)
        } content: {
            List {
                ProjectTodoListView(projects: viewModel.selectedProjects)
            }
            .navigationSplitViewColumnWidth(min: 462, ideal: 690, max: 900)

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
                        isSelected = true
                    } label: {
                        Image(systemName: "folder")
                            .foregroundColor(isSelected ? Color(red: 0, green: 0.48, blue: 1) : Color.gray)

                    }
                    Button {
                        isSelected = false
                    } label: {
                        Image(systemName: "list.clipboard")
                            .foregroundColor(isSelected ? Color.gray : Color(red: 0, green: 0.48, blue: 1))

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
