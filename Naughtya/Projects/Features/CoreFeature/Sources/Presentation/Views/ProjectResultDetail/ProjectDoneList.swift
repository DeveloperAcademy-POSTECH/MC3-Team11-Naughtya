//
//  ProjectDoneList.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectDoneList: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy
    private let ability: AbilityEntity

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy,
        ability: AbilityEntity
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
        self.ability = ability
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("달성한 일")
                    .font(
                        .system(size: 32)
                            .weight(.bold)
                    )
                    .padding(.vertical, 35 * geometry.size.height / 892)
                    .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                ScrollView(.vertical) {
//                    ForEach(1..<10) { _ in
//                        HStack {
//                            Image(systemName: "checkmark.square.fill")
//                                .font(
//                                    .system(size: 16)
//                                    .weight(.medium)
//                                )
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(Color(red: 0.02, green: 0.32, blue: 0.98))
//                            Text("할 일이 어쩌고 저쩌고")
//                                .font(
//                                    .system(size: 16)
//                                )
//                                .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
//                                .padding(.vertical, 10) // 화면 비율에 따라
//                        }
//                    }
                    ForEach(Array(ability.todos.enumerated()), id: \.offset) { _, todo in
                        HStack {
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 18  * (geometry.size.height / 892)))
                                .foregroundColor(.pointColor)
                            Text(todo.title.value)
                                .font(.system(size: 18  * (geometry.size.height / 892)))
                                .padding(.vertical, 10)
                                .lineLimit(1)
                        }

                    }
                }
            }
            .padding(.leading, 30)
            Spacer()
        }
        .background(Color.customGray8)
    }
}
