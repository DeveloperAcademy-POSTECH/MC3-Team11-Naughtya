//
//  ResultCompleteTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultCompleteTodoView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {
        HStack {

            HStack {
                Text(" 10개의 능력을 획득 했어요")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 42)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)

                Image(systemName: "arrow.right")
                    .frame(width: 33, height: 19)
            }

            Spacer()

            HStack {
                Text("􀁜")
                    .font(Font.custom("SF Pro", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                Text("평균 To do 달성률")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 16)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                Text("94%")
                    .font(
                        Font.custom("SF Pro", size: 20)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                    .frame(width: 46, height: 14, alignment: .center)

                Text("달성 To-do 갯수")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 16)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
                Text("100/100")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 20)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 32)

            .background(Color(red: 0.18, green: 0.18, blue: 0.18).opacity(0.5))
            .cornerRadius(8)
        }
        .padding(.bottom, 35)
        .padding(.trailing, 30)
    }
}

struct ResultCompleteTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCompleteTodoView()
    }
}
