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
                Text("\(projectResult.abilitiesCount)개의 능력을 획득 했어요")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 42  * (geometry.size.width/1512))
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                    .lineLimit(1)
                Image(systemName: "chevron.forward")

                    .padding(.bottom, 3)

                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 35  * (geometry.size.width/1512))
                    )
                    .foregroundColor(.white)
            }
            Spacer()

            HStack(spacing: 20  * (geometry.size.width/1512)) {
                Text("􀁜")
                    .font(Font.custom("SF Pro", size: 16   * (geometry.size.width/1512)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                Text("평균 To do 달성률")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 16   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                Text("\(projectResult.completedPercent)%")
                    .font(
                        Font.custom("SF Pro", size: 20   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                    .frame(width: 46, height: 14, alignment: .center)
                    .padding(.trailing, 35  * (geometry.size.width/1512))

                Text("달성 To-do 갯수")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 16   * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                Text("\(projectResult.completedCount)/\(projectResult.allTodosCount)")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 20   * (geometry.size.width/1512))
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
            }
            .padding(.vertical, 12 * geometry.size.height / 892)
            .padding(.horizontal, 40)
            .background(Color(red: 0.18, green: 0.18, blue: 0.18).opacity(0.5))
            .cornerRadius(8)
        }
    }
}

//
// import SwiftUI
//
// public struct ResultCompleteTodoView: View {
//    let geometry: GeometryProxy
//
//    public init(geometry: GeometryProxy) {
//        self.geometry = geometry
//    }
//    public var body: some View {
//        HStack {
//
//            HStack {
//                Text("10개의 능력을 획득 했어요")
//                    .font(
//                        Font.custom("Apple SD Gothic Neo", size: 42 * (geometry.size.width/1512))
//                            .weight(.bold)
//                    )
//                    .foregroundColor(.white)
//
//                Image(systemName: "chevron.compact.right")
////                    .frame(width: 33, height: 19)
//                    .font(
//                        Font.custom("Apple SD Gothic Neo", size: 42 * (geometry.size.width/1512))
//
//                    )
//                    .foregroundColor(.white)
//            }
//
//            Spacer()
//
//            HStack(spacing: 20) {
//                Text("􀁜")
//                    .font(Font.custom("SF Pro", size: 16 * (geometry.size.width/1512)))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
//                Text("평균 To do 달성률")
//                    .font(
//                        Font.custom("Apple SD Gothic Neo", size: 16 * (geometry.size.width/1512))
//                            .weight(.semibold)
//                    )
//                    .foregroundColor(.white)
//                Text("94%")
//                    .font(
//                        Font.custom("SF Pro", size: 20 * (geometry.size.width/1512))
//                            .weight(.semibold)
//                    )
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
//                    .frame(width: 46, height: 14, alignment: .center)
//                    .padding(.trailing, 10)
//
//
//                Text("달성 To-do 갯수")
//                    .font(
//                        Font.custom("Apple SD Gothic Neo", size: 16 * (geometry.size.width/1512))
//                            .weight(.semibold)
//                    )
//                    .foregroundColor(.white)
//                Text("100/100")
//                    .font(
//                        Font.custom("Apple SD Gothic Neo", size: 20 * (geometry.size.width/1512))
//                            .weight(.bold)
//                    )
//                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
//            }
//            .padding(.vertical, 12 * geometry.size.height / 892)
//            .padding(.leading, 20)
//            .padding(.trailing, 20)
//
//            .background(Color(red: 0.18, green: 0.18, blue: 0.18).opacity(0.5))
//            .cornerRadius(8)
//        }
//    }
// }
