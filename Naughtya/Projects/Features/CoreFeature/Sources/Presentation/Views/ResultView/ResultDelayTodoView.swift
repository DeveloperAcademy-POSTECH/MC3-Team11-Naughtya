//
//  ResultDelayTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultDelayTodoView: View {
    let geometry: GeometryProxy

    public init(geometry: GeometryProxy) {
        self.geometry = geometry
    }
    let delayTodos = ["김동혁", "하요", "김김혁"]
    @State private var currentIndex = 0
    @State private var offsetY: CGFloat = 0

    public var body: some View {
        VStack(alignment: .leading, spacing: 27) {
            Text("Top3 미룬 To-DO")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 24 * (geometry.size.width/1512))
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack(alignment: .leading, spacing: 23) {

                HStack {
                    VStack {
                        Text("\(currentIndex + 1)")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 13.83245 * (geometry.size.width/1512))
                                    .weight(.semibold)
                            )

                            .foregroundColor(Color(red: 0.77, green: 0.77, blue: 0.77))
                    }
                    .offset(y: offsetY)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.27, green: 0.27, blue: 0.27))
                    .cornerRadius(5)

                    Text("\(delayTodos[currentIndex])")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 18 * (geometry.size.width/1512))
                                .weight(.semibold)
                        )
                        .offset(y: offsetY)
                        .padding(.vertical, 5)
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                    Spacer()

                    Text("총 3회")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 18 * (geometry.size.width/1512))
                                .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.52))
                }

                Text("다음번에 성공한다면 플러터 개발 능력을 획득 할 수 있어요!")
                    .font(Font.custom("Apple SD Gothic Neo", size: 16 * (geometry.size.width/1512)))
                    .foregroundColor(Color(red: 0.86, green: 0.86, blue: 0.86))

            }
            .padding(.leading, 50)
            .padding(.trailing, 102)
            .padding(.vertical, 36)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
            .frame(maxWidth: 756)
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
                currentIndex = (currentIndex + 1) % delayTodos.count
            }
        }
    }
}
