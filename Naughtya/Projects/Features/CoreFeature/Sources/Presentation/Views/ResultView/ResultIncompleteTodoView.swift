//
//  ResultIncompleteTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultIncompleteTodoView: View {
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

    var incompleteMessage1: AttributedString {
        var result = AttributedString("이번에 ")
        result.foregroundColor = .customGray2
        result.font = .appleSDGothicNeo(size: 18  * (geometry.size.height/892), weight: .semibold)
        return result
    }

    var incompleteMessage3: AttributedString {
        var result = AttributedString("은/는 이루지 못했어도,")
        result.foregroundColor = .customGray2
        result.font = .appleSDGothicNeo(size: 18  * (geometry.size.height/892), weight: .semibold)
        return result
    }
    var incompleteResult1: AttributedString {
        var result = AttributedString("다음에 성공하면 ")
        result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892))
        result.foregroundColor = .customGray1
        return result
    }

    var incompleteResult3: AttributedString {
        var result = AttributedString("을/를 기록 할 수 있어요!")
        result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892))
        result.foregroundColor = .customGray1
        return result
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 27 * geometry.size.height / 892) {
            Text("미완료 한 일")
                .font(
                    .appleSDGothicNeo(size: 24  * (geometry.size.height/892))
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack(alignment: .leading, spacing: 23) {

                if projectResult.incompletedTodos.isEmpty {
                    HStack {

                            Text("모두 달성했습니다! 대단해용")
                                .font(
                                    .appleSDGothicNeo(size: 18)
                                        .weight(.bold)
                                )
                                .offset(y: offsetY)
                                .padding(.vertical, 5)
                                .lineLimit(1)
                            Spacer()
                    }
                } else {

                    let todo = projectResult.incompletedTodos[currentIndex]

                    var incompleteMessage2: AttributedString {
                        var result = AttributedString(todo.title)
                        result.foregroundColor = .white
                        result.font = .appleSDGothicNeo(size: 18  * (geometry.size.height/892), weight: .bold)
                        return result
                    }
                    HStack {

                            Text(incompleteMessage1 + incompleteMessage2 + incompleteMessage3)
                                .font(
                                    .appleSDGothicNeo(size: 18)
                                        .weight(.bold)
                                )
                                .offset(y: offsetY)
                                .padding(.vertical, 5)
                                .lineLimit(1)
                            Spacer()
                    }

                    if let abilityTitle = projectResult.getAbilityTitleFromTodo(
                        todo,
                        category: .incompleted
                    ) {
                        var incompleteResult2: AttributedString {
                            var result = AttributedString(abilityTitle)
                            result.foregroundColor = .white
                            result.font = .appleSDGothicNeo(size: 16  * (geometry.size.height/892), weight: .bold)
                            return result
                        }

                            Text(incompleteResult1 + incompleteResult2 + incompleteResult3)
                            .font(.appleSDGothicNeo(size: 16))
                                .lineLimit(1)

                    }
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
            withAnimation {
                offsetY = -30 // Move the current item upward
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Restore the offset to the original position after the animation is done
                offsetY = 0
                currentIndex = (currentIndex + 1) % projectResult.incompletedTodos.count
            }
        }
    }
}

// struct ResultIncompleteTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultIncompleteTodoView(projectResult: .from(entity: ProjectResultEntity.sample))
//    }
// }
