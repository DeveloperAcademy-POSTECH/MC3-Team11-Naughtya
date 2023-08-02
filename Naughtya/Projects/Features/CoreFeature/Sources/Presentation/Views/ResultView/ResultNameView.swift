//
//  ResultNameView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultNameView: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy
    @State private var isHovered: Bool = false

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
    }

    public var body: some View {
        let relativeWidth = geometry.size.width / 1512
        let relativeHeight = geometry.size.height / 892
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(projectResult.projectName) 프로젝트")
                    .lineLimit(1)
                    .font(.appleSDGothicNeo(size: 32 * relativeWidth, weight: .bold))
                    .foregroundColor(.customGray1)
                Text("\(projectResult.daysInProject)일간의 능력로그")
                    .lineLimit(1)
                    .font(.appleSDGothicNeo(size: 28 * relativeWidth, weight: .medium))
                    .foregroundColor(.customGray2)
                    .padding(.vertical, 10)
            }
            Spacer()
            VStack(spacing: 8 * relativeWidth) {
                let scale = isHovered ? 1.1 : 1
                MacOSCoreFeatureAsset.circle.swiftUIImage
                    .resizable()
                    .frame(width: 86 * relativeWidth, height: 86 * relativeWidth)
                    .scaleEffect(x: scale, y: scale)
                    .animation(.easeIn, value: isHovered)
                    .onHover {
                        isHovered = $0
                    }
                Text("에필로그")
                    .foregroundColor(.white)
                    .font(.appleSDGothicNeo(size: 16 * relativeHeight, weight: .semibold))
            }
        }
        .padding(.horizontal, 6)
    }
}
