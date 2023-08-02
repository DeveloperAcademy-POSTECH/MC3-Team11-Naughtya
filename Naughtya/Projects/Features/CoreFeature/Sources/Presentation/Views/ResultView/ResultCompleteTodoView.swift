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
    private var pageNum: Binding<Int>

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy,
        pageNum: Binding<Int>
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
        self.pageNum = pageNum
    }

    public var body: some View {
        let relativeWidth = (geometry.size.width / 1512)
        let relativeHeight = (geometry.size.height / 892)
        HStack {
            HStack {
                Text("\(projectResult.abilitiesCount)개의 능력을 기록했어요")
                    .font(.appleSDGothicNeo(size: 42 * relativeWidth, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Button {
                    pageNum.wrappedValue = 2
                } label: {
                    Image(systemName: "chevron.compact.right")
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderless)
                .padding(.bottom, 3)
                .font(.appleSDGothicNeo(size: 35 * relativeWidth))
                .foregroundColor(.white)
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Image(systemName: "questionmark.circle")
                    .font(.appleSDGothicNeo(size: 20 * relativeWidth, weight: .semibold))
                    .foregroundColor(.customGray4)
                Color.clear
                    .frame(width: 25 * relativeWidth, height: 1)
                HStack(alignment: .firstTextBaseline, spacing: 14) {
                    Text("평균 할 일 달성률")
                        .font(.appleSDGothicNeo(size: 16 * relativeWidth, weight: .semibold))
                        .foregroundColor(.white)
                    Text("\(projectResult.completedPercent)%")
                        .font(.appleSDGothicNeo(size: 20 * relativeWidth, weight: .semibold))
                        .foregroundColor(.pointColor)
                }
                Color.clear
                    .frame(width: 50 * relativeWidth, height: 1)
                HStack(alignment: .firstTextBaseline, spacing: 14) {
                    Text("할 일 달성 갯수")
                        .font(.appleSDGothicNeo(size: 16 * relativeWidth, weight: .semibold))
                        .foregroundColor(.white)
                    HStack(spacing: 0) {
                        Text("\(projectResult.completedCount)")
                            .font(.appleSDGothicNeo(size: 20 * relativeWidth, weight: .semibold))
                            .foregroundColor(.pointColor)
                        Text("/\(projectResult.allTodosCount)")
                            .font(.appleSDGothicNeo(size: 12 * relativeWidth, weight: .semibold))
                            .foregroundColor(.customGray1)
                    }
                }
            }
            .padding(.vertical, 12 * relativeHeight)
            .padding(.leading, 25 * relativeWidth)
            .padding(.trailing, 43 * relativeWidth)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.customGray8.opacity(0.5))
            )
        }
    }
}
