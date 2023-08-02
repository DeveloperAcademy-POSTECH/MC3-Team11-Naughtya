//
//  EpilogObjectView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct EpilogObjectView: View {
    let model: EpilogObjectModel

    var body: some View {
        HStack {
            if !model.isLeading {
                Spacer()
            }
            let image = MacOSCoreFeatureImages(name: model.imageName)
            image.swiftUIImage
                .offset(x: (image.image.size.width / 2) * (model.isLeading ? -1 : 1))
            if model.isLeading {
                Spacer()
            }
        }
    }
}
