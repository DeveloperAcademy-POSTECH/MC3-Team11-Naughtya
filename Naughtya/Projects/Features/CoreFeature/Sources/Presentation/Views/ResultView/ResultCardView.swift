//
//  ResultCardView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultCardView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {

        VStack {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 34) {
                    ForEach(0..<50, id: \.self) { num in
                        Text("\(num)")
                            .frame(width: 185, height: 253)
                            .background(Color.black)

                    }
                }.padding(.leading, 34)

            }

            HStack(alignment: .center, spacing: 8) {
                Text("􀯷")
                    .font(
                        Font.custom("SF Pro", size: 16)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                Text("1/3 ")
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
            .padding(10)
        }

    }
}

struct ResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCardView()
    }
}
