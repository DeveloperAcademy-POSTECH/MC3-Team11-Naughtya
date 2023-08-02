//
//  CreditsObjectView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct CreditsObjectView: View {
    let model: CreditsObjectModel

    var body: some View {
        HStack {
            if !model.isLeading {
                Spacer()
            }
            MacOSCoreFeatureImages(name: model.imageName)
                .swiftUIImage
            if model.isLeading {
                Spacer()
            }
        }
    }
}
