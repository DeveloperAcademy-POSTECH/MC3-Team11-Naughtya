//
//  ProjectDoneList.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectDoneList: View {
    let geometry: GeometryProxy

    public init(geometry: GeometryProxy) {
        self.geometry = geometry
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
                    ForEach(1..<10) { _ in
                        HStack {
                            Text("􀂒")
                                .font(
                                    .system(size: 16)
                                    .weight(.medium)
                                )
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(red: 0.02, green: 0.32, blue: 0.98))
                            Text("할 일이 어쩌고 저쩌고")
                                .font(
                                    .system(size: 16)
                                )
                                .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                                .padding(.vertical, 10) // 화면 비율에 따라
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
