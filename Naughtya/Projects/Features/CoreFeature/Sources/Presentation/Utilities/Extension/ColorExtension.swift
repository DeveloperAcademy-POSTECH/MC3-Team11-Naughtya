//
//  ColorExtension.swift
//  MacOSCoreFeature
//
//  Created by Greed on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

// 원하는 컬러 생성
public extension Color {
    static let customBlack = Color.rgb(27, 27, 27)
    static let customGray1 = Color.rgb(224, 224, 224)
    static let customGray2 = Color.rgb(131, 131, 131)
    static let customGray3 = Color.rgb(102, 102, 102)
    static let customGray4 = Color.rgb(79, 79, 79)
    static let customGray5 = Color.rgb(70, 70, 70)
    static let customGray6 = Color.rgb(58, 58, 58)
    static let customGray7 = Color.rgb(47, 47, 47)
    static let customGray8 = Color.rgb(47, 47, 47)
    static let customGray9 = Color.rgb(32, 32, 32)
    static let pointColor = Color.rgb(4, 82, 249)

    private static func rgb(_ red: Int, _ green: Int, _ blue: Int) -> Color {
        Color(
            red: Double(red) / Double(255),
            green: Double(green) / Double(255),
            blue: Double(blue) / Double(255)
        )
    }
}
