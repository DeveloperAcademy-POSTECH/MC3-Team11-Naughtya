//
//  ProjectResultDetailView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultDetailView: View {
//    private static let projectResultUseCase: ProjectResultUseCase = DefaultProjectResultUseCase()
//
//    @State private var projectResults: [ProjectResultModel] = []
//
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
//    public let projectResult: ProjectResultModel
//
//    public init(projectResult: ProjectResultModel) {
//        self.projectResult = projectResult
//    }

    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy
    @State private var selectedAbility: AbilityEntity?

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy

    ) {
        self.projectResult = projectResult
        self.geometry = geometry

    }

    public var body: some View {

        GeometryReader { geometry in
            HStack {
                VStack {
                    NavigationStack {
                        NavigationView {
                            VStack {
                                ResultDetailNameView(projectResult: projectResult, geometry: geometry)
                                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                                ScrollView(.vertical) {
                                    LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 10) {

                                        ForEach(projectResult.abilities) { ability in
                                            ProjectDetailCard(projectResult: projectResult, geometry: geometry, ability: ability)
                                                .onTapGesture {
                                                    selectedAbility = ability
                                                }
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 25))
                                    }
                                }
                            }
                            .padding(.leading, 30)
                            .frame(minWidth: 850)
                            if let ability = selectedAbility {
                                ProjectDoneList(projectResult: projectResult, geometry: geometry, ability: ability)
                                    .frame(minWidth: 250)
                            }
                        }
                    }
                }

            }
            .background(Color.customGray8)

        }
    }

//    private func fetchProjectResults() {
//        Task {
//            projectResults = try await Self.projectResultUseCase.readList()
//                .map { .from(entity: $0) }
//        }
//    }
}
