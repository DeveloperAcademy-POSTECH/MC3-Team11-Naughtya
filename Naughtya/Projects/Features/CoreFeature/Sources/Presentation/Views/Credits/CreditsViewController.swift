//
//  CreditsViewController.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

final class CreditsViewController: NSViewController {
    var projectResult: ProjectResultModel!

    private lazy var scrollView = {
        let view = NSScrollView()
        view.backgroundColor = .red
        view.hasVerticalScroller = true
        return view
    }()

    private lazy var todoListController = {
        let view = CreditsTodoListView(projectResult: projectResult)
        let controller = NSHostingController(rootView: view)
        return controller
    }()

    override func loadView() {
        view = NSView()
        view.addSubviewWithConstraints(scrollView)
//        scrollView.documentView = todoListController.view
//        print(scrollView.bounds.size)
        view.layer?.layoutIfNeeded()
    }
}

extension CreditsViewController: NSCollectionViewDelegate {
}

extension NSView {
    func addSubviewWithConstraints(_ view: NSView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
