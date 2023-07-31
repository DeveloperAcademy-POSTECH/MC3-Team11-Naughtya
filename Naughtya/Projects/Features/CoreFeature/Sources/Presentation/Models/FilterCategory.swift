//
//  FilterCategory.swift
//  CoreFeature
//
//  Created by byo on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public enum FilterCategory: String, CaseIterable {
    case incompleted
    case completed
    case all

    public var title: String {
        switch self {
        case .incompleted:
            return "􀀀 미완료 to do"
        case .completed:
            return "􀁢 완료 to do"
        case .all:
            return "전체보기"
        }
    }
}
