//
//  ResultDelayTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultDelayTodoView: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy
    @State private var currentIndex = 0
    @State private var offsetY: CGFloat = 0

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
    }

    var delayResult1: AttributedString {
        var result = AttributedString("미뤘어도 이루어낸 당신! ")
        result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892))
        result.foregroundColor = .customGray1
        return result
    }

    var delayResult3: AttributedString {
        var result = AttributedString("이/가 기록됐어요.")
        result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892))
        result.foregroundColor = .customGray1
        return result
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 27 * geometry.size.height / 892) {
            Text("미룬 할 일 Top3")
                .font(
                    .appleSDGothicNeo(size: 24  * (geometry.size.height/892))
                    .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack(alignment: .leading, spacing: 23) {
                let todo = projectResult.top3DelayedTodos[currentIndex]
                HStack {
                    VStack {
                        Text("\(currentIndex + 1)")
                            .font(
                                .appleSDGothicNeo(size: 13.83245  * (geometry.size.height/892))
                                .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0.77, green: 0.77, blue: 0.77))
                    }
                    //                    .offset(y: offsetY)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.27, green: 0.27, blue: 0.27))
                    .cornerRadius(5)
                    Text(todo.title)
                        .font(
                            .appleSDGothicNeo(size: 18  * (geometry.size.height/892))
                            .weight(.semibold)
                        )
                        .offset(y: offsetY)
                        .padding(.vertical, 5)
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                    Spacer()
                    Text("총 \(todo.delayedCount)회")
                        .font(
                            .appleSDGothicNeo(size: 18  * (geometry.size.height/892))
                            .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    //                        .frame(width: 46, height: 13, alignment: .center)
                }
                if let abilityTitle = projectResult.getAbilityTitleFromTodo(
                    todo,
                    category: .performance
                ) {
                    var delayResult2: AttributedString {
                        var result = AttributedString(abilityTitle)
                        result.foregroundColor = .white
                        result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892), weight: .bold)
                        return result
                    }
                    Text(delayResult1 + delayResult2 + delayResult3)
                        .font(.appleSDGothicNeo(size: 16))
                        .lineLimit(1)
                }
            }
            .padding(.leading, 50)
            .padding(.trailing, 44)
            .padding(.vertical, 36 * geometry.size.height / 892)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
            //            .frame(maxWidth: 620)
            .onAppear {
                // Start the timer when the view appears
                startTimer()
            }
        }
    }

    func startTimer() {
        // Schedule a repeating timer with 5-second interval
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            // Update the current index to show the next item in the list
            withAnimation(.easeInOut(duration: 0.3)) {
                offsetY = -30 // Move the current item upward
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Restore the offset to the original position after the animation is done
                offsetY = 0
                currentIndex = (currentIndex + 1) % projectResult.top3DelayedTodos.count
            }
        }
    }
}
