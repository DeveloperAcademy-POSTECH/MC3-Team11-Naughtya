//
//  Font+Helper.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public extension Font {
    static func appleSDGothicNeo(
        size: CGFloat,
        weight: Font.Weight = .regular
    ) -> Font {
        .custom(
            "Apple SD Gothic Neo",
            size: size
        )
        .weight(weight)
    }
}
