//
//  ResultPageView.swift
//  MacOSApp
//
//  Created by 김정현 on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import MacOSCoreFeature

struct ResultPageView: View {

    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ProjectResultSideBarView(projects: viewModel.projects)
                }
                .frame(width: 298)
                VStack(alignment: .leading) {
                    ResultTopView(projects: viewModel.projects)
                        .padding(EdgeInsets(top: 40, leading: 40, bottom: 0, trailing: 0))
                    VStack {
                        HStack {
                            // ResultSuccessView(project: viewModel.projects)
                        }
                        HStack {
                            ProjectResultCardView()
                        }
                        HStack {
                            Rectangle()
                            // ResultTopThreeTodoView()
                            Rectangle()
                            // ResultTopThreeUndoView()

                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 71, bottom: 0, trailing: 0))
                }
            }
        }
    }

}
struct ResultPageView_Previews: PreviewProvider {
    static var previews: some View {
        ResultPageView()
    }
}
