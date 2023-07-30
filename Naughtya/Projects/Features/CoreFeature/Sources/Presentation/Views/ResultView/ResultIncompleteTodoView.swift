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

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    @State private var currentIndex = 0
    @State private var offsetY: CGFloat = 0

    public var body: some View {
        VStack(alignment: .leading, spacing: 27) {
            Text("미완료 To-Do")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 24)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack(alignment: .leading, spacing: 23) {
                let todo = projectResult.incompletedTodos[currentIndex]
                Text(todo.title)
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 18)
                            .weight(.semibold)
                    )
                    .offset(y: offsetY)
                    .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                if let abilityTitle = projectResult.getAbilityTitleFromTodo(
                    todo,
                    category: .incompleted
                ) {
                    Text("다음번에 성공한다면 \(abilityTitle)을 획득 할 수 있어요!")
                        .font(Font.custom("Apple SD Gothic Neo", size: 16))
                        .foregroundColor(Color(red: 0.86, green: 0.86, blue: 0.86))
                }
            }
            .padding(.leading, 50)
            .padding(.trailing, 102)
            .padding(.vertical, 36)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
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

struct ResultIncompleteTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultIncompleteTodoView(projectResult: .from(entity: ProjectResultEntity.sample))
    }
}
