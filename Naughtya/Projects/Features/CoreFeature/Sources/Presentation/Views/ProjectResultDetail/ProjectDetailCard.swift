//
//  ProjectDetailCard.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectDetailCard: View {
    let geometry: GeometryProxy

    public init(geometry: GeometryProxy) {
        self.geometry = geometry
    }

    var body: some View {
        Rectangle()
            .frame(minWidth: 200, minHeight: 130)
            .foregroundColor(.clear)
            .background(Color.customGray7)
            .cornerRadius(14.76642)
            .overlay(
                HStack(spacing: 0) {
                    Text("포트폴리오 작성 능력 개선")
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

}
