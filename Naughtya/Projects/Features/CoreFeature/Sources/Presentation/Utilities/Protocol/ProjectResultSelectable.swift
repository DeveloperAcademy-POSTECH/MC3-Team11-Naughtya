//
//  ProjectSelectable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/30.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol ProjectResultSelectable: AnyObject {
    func selectProjectResult(_ projectResult: ProjectResultModel)
}
