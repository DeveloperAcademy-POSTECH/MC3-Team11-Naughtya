//
//  CreditsView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct CreditsView: View {
    let projectResult: ProjectResultModel
    @State private var offset: CGPoint = .zero

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        GeometryReader { geometry in
            OffsetObservingScrollView(offset: $offset) {
                ZStack(alignment: .bottom) {
                    bottomObjectView
                    todoListView
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .background {
                ZStack {
                    backgroundView
                    buildObjectsView(width: geometry.size.width)
                }
                .offset(y: -offset.y / 2)
            }
        }
    }

    private var todoListView: some View {
        VStack(spacing: 100) {
            VStack(spacing: 26) {
                Text(projectResult.projectName)
                    .font(.system(size: 80).weight(.bold))
                VStack(spacing: 5) {
                    Text("2023.01.01 ~ 2024.01.01")
                        .fontWeight(.medium)
                    if let goals = projectResult.project.goals {
                        Text("\(goals) 위해서")
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 20))
            }
            HStack {
                Spacer()
                CreditsTodoListView(projectResult: projectResult)
                Spacer()
            }
        }
        .padding(.top, 100)
        .padding(.bottom, 200)
    }

    private var bottomObjectView: some View {
        Circle()
            .frame(
                width: 400,
                height: 400
            )
            .offset(y: 300)
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                .red,
                .blue
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func buildObjectsView(width: CGFloat) -> some View {
        VStack(spacing: 200) {
            ForEach(0 ..< 10) { _ in
                CreditsObjectView(offsetX: .random(in: -width / 2 ... width / 2))
            }
        }
    }

    private func setupAutoScrolling() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            offset = CGPoint(
                x: 0,
                y: offset.y + 1
            )
        }
    }
}
