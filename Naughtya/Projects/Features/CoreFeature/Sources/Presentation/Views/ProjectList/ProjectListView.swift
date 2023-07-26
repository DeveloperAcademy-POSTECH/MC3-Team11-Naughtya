//
//  pr.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects.sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    @State private var showModal = false

    public var body: some View {
        ZStack {
            VStack(spacing: 16) {
                List {
                    Section(header: ListHeaderView()) {
                        ForEach(projects) { project in
                            ProjectCardView(project: project)
                        }
                    }
                }
                .listStyle(.plain)
            }
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Button(action: {
                    self.showModal = true
                }) {
                    HStack(alignment: .center, spacing: 5) {
                        Text("+")
                          .font(Font.custom("SF Pro", size: 20))
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)

                        Text("Add project")
                          .lineLimit(1)
                          .font(Font.custom("SF Pro", size: 14))
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .center)
                    .background(Color.pointColor)
                    .cornerRadius(10)
                    .shadow(color: Color(red: 0.28, green: 0.27, blue: 1), radius: 0.2, x: 1, y: 1)
                }
                .padding(15)
                .sheet(isPresented: self.$showModal) {
                    ProjectSetModalView()
                }
                .buttonStyle(.borderless)
                .onAppear { // MARK: - 테스트 후 삭제(가짜데이터)
                    Task {
                        try await Self.projectUseCase.create(
                            category: "MC3",
                            goals: "mc2",
                            startedAt: Date(),
                            endedAt: Date()
                        )
                    }
                }

            }
            .padding(.horizontal, 57)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct ListHeaderView: View {
    @State private var showModal = false
    var body: some View {
        HStack {
            Text("All My Projects")
              .font(
                Font.custom("SF Pro", size: 12)
                  .weight(.bold)
              )
              .foregroundColor(Color.customGray3)
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
