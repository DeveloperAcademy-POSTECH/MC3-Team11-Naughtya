//
//  ResultCompleteTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultCompleteTodoView: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
    }

    public var body: some View {
        HStack {
            HStack {
                Text("\(projectResult.abilitiesCount)개의 능력을 기록했어요")
                    .font(
                        .system(size: 42  * (geometry.size.width/1512))
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                    .lineLimit(1)
                Image(systemName: "chevron.forward")

                    .padding(.bottom, 3)

                    .font(
                        .system(size: 35  * (geometry.size.width/1512))
                    )
                    .foregroundColor(.white)
            }
            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 20  * (geometry.size.width/1512)) {
                Text("􀁜")
                    .font(.system(size: 20 * (geometry.size.width/1512)))
                    .fontWeight(.semibold)
                //                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                Text("평균 할 일 달성률")
                    .font(
                        .system(size: 16   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                Text("\(projectResult.completedPercent)%")
                    .font(
                        .system(size: 20   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )

                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
//                    .frame(width: 46, height: 14, alignment: .center)
                    .padding(.trailing, 25  * (geometry.size.width/1512))

                Text("할 일 달성 갯수")
                    .font(
                        .system(size: 16   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(projectResult.completedCount)/")
                        .font(
                            .system(size: 20   * (geometry.size.width/1512))
                                .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 0, green: 0.48, blue: 1))

                    Text("\(projectResult.allTodosCount)")
                        .font(
                            .system(size: 12   * (geometry.size.width/1512))
                                .weight(.semibold)
                        )
                        .foregroundColor(.customGray1)

                }

            }
            .padding(.vertical, 12 * geometry.size.height / 892)
            .padding(.horizontal, 40)
            .background(Color.customGray8.opacity(0.5))
//            .background(.ultraThinMaterial)

            .cornerRadius(8)
        }
    }
}
