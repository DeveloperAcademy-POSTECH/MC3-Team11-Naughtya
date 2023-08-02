//
//  EpilogViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class EpilogViewModel: ObservableObject {
    @Published var rootViewHeight: Int = 0
    @Published var todoListViewHeight: Int = 0
    @Published var offsetY: Int = 0
    @Published var offsetReadOnly: CGPoint = .zero
    @Published var isManualScrolling: Bool = false

    func setupAutoScrolling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                guard offsetY <= Int(todoListViewHeight - rootViewHeight) else {
                    return
                }
                offsetY += 1
            }
        }
    }
}
