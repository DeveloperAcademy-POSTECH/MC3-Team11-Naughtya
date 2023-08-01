//
//  ProjectSelectable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/30.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol ProjectSelectable: AnyObject {
    func selectProject(_ project: ProjectEntity)
}
