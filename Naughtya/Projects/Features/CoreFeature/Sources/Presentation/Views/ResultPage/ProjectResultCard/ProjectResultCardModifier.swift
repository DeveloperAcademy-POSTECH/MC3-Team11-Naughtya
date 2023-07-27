//
//  ProjectResultCardView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultCardModifier: ViewModifier {

    public init() {}
    public func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .frame(width: 227, height: 269)
            .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5))
            .cornerRadius(7.99087)

    }
}
//
// struct ProjectResultCardModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectResultCardModifier()
////    }
// }
