//
//  DragDropDelegate.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol DragDropDelegate: AnyObject {
    func registerAbsoluteRect(
        _ hash: DragDropableHash,
        rect: CGRect
    )

    func unregisterAbsoluteRect(_ hash: DragDropableHash)

    func startToDrag(
        _ item: DragDropItemable,
        size: CGSize,
        itemLocation: CGPoint
    )

    func drag(
        _ item: DragDropItemable,
        itemLocation: CGPoint
    )

    func drop(
        _ item: DragDropItemable,
        touchLocation: CGPoint
    )
}
