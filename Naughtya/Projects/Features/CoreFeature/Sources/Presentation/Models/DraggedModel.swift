//
//  DraggedModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct DraggedModel {
    let item: DragDropItemable
    let size: CGSize
    var location: CGPoint

    var rect: CGRect {
        CGRect(
            origin: location,
            size: size
        )
    }
}
