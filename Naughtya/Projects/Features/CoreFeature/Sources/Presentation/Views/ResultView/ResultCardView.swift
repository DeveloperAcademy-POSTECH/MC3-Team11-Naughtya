//
//  ResultCardView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultCardView: View {
    public let projectResult: ProjectResultModel

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 34) {
                    ForEach(projectResult.abilities) { ability in
                        buildAbilityCardView(ability)
                    }
                }
                .padding(.horizontal, 36)
            }
            HStack(alignment: .center, spacing: 8) {
                Text("􀯷")
                    .font(
                        Font.custom("SF Pro", size: 16)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                Text("1/3")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 23)
                            .weight(.semibold)
                    )
                    .kerning(0.46)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                Text("􀁴")
                    .font(
                        Font.custom("SF Pro", size: 16)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            }
            .padding(27)
        }
    }

    private func buildAbilityCardView(_ ability: AbilityEntity) -> some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Text("총 \(ability.todos.count)개")
                    .foregroundColor(.pointColor)
                    .font(.system(size: 10))
                    .padding(.horizontal, 7)
                    .frame(height: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.pointColor, lineWidth: 1)
                    )
            }
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(ability.title)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 18))
                            .lineLimit(2)
                            .lineSpacing(14)
                        Spacer()
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 5) {
                    let colors: [Color] = [.customGray4, .customGray5, .customGray6]
                    ForEach(Array(ability.todos.enumerated()).prefix(3), id: \.offset) { todoIndex, todo in
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.square.fill")
                                .font(.system(size: 18))
                            Text(todo.title.value)
                                .font(.system(size: 14))
                                .lineLimit(1)
                        }
                        .foregroundColor(colors[todoIndex])
                    }
                }
                .padding(.top, 84)
            }
            .padding(.horizontal, 10)
            Button {
            } label: {
                HStack {
                    Spacer()
                    Text("더보기")
                    Spacer()
                }
                .foregroundColor(.customGray2)
                .frame(height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.customGray6)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(
            EdgeInsets(
                top: 14,
                leading: 20,
                bottom: 16,
                trailing: 20
            )
        )
        .frame(
            width: 225,
            height: 269
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.customGray8) // TODO: figma 업데이트 필요
        )
    }
}

struct ResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCardView(projectResult: .from(entity: ProjectResultEntity.sample))
    }
}
