//
//  ProjectDetailCard.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectDetailCard: View {
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
        Rectangle()
//            .frame(minWidth: 200 * (geometry.size.width / 1512), minHeight: 130 * (geometry.size.height / 892))
            .frame(minWidth: 200, minHeight: 130)
            .foregroundColor(.clear)
            .background(Color.customGray7)
            .cornerRadius(14.76642)
            .overlay(
                HStack(spacing: 0) {
                    Text(ability.title)
                        .font(.custom("dungeunmo", size: 18))
                        .fontWeight(.medium)
                        .padding(.leading, 30)
                    Spacer()
                    Image(systemName: "chevron.right")
                            .font(.custom("dungeunmo", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color.customGray3)

                        .padding(.trailing, 30)
                }

            )

    }

//    private func buildAbilityDoneCardView(_ ability: AbilityEntity) -> some View {
//
//            VStack(spacing: 8) {
//                HStack {
//                    Spacer()
//                    Text("총 \(ability.todos.count)개")
//                        .foregroundColor(.pointColor)
//                        .font(.system(size: 10  * (geometry.size.height / 892)))
//                        .padding(.horizontal, 7  * (geometry.size.height / 892))
//                        .frame(height: 16 * (geometry.size.height / 892))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 2)
//                                .stroke(Color.pointColor, lineWidth: 1)
//                        )
//                }
//                ZStack(alignment: .topLeading) {
//                    VStack(alignment: .leading, spacing: 0) {
//                        HStack {
//                            Text(ability.title)
//                                .multilineTextAlignment(.leading)
//                                .font(.system(size: 18  * (geometry.size.height / 892)))
//                                .lineLimit(2)
//                                .lineSpacing(14)
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                    VStack(alignment: .leading, spacing: 5) {
//                        let colors: [Color] = [.customGray4, .customGray5, .customGray6]
//                        ForEach(Array(ability.todos.enumerated()).prefix(3), id: \.offset) { todoIndex, todo in
//                            HStack(spacing: 4) {
//                                Image(systemName: "checkmark.square.fill")
//                                    .font(.system(size: 18  * (geometry.size.height / 892)))
//                                Text(todo.title.value)
//                                    .font(.system(size: 14  * (geometry.size.height / 892)))
//                                    .lineLimit(1)
//                            }
//                            .foregroundColor(colors[todoIndex])
//                        }
//                    }
//                    .padding(.top, 84 * (geometry.size.height/892))
//                }
//                .padding(.horizontal, 10 * (geometry.size.height / 892))
//                Button {
//                    self.pageNum.wrappedValue = 2
//                } label: {
//                    HStack {
//                        Spacer()
//                        Text("더보기")
//                            .font(.system(size: 14  * (geometry.size.height / 892)))
//                        Spacer()
//                    }
//                    .foregroundColor(.customGray2)
//                    .frame(height: 32 * (geometry.size.height / 892))
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(Color.customGray6)
//                    )
//                }
//                .buttonStyle(.plain)
//            }
//            .padding(
//                EdgeInsets(
//                    top: 24 * (geometry.size.height / 892),
//                    leading: 20,
//                    bottom: 16 * (geometry.size.height / 892),
//                    trailing: 20
//                )
//            )
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//
//                    .fill(Color.customGray8.opacity(0.5)
//
//                         ) // TODO: figma 업데이트 필요
//
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//
//    }

}
