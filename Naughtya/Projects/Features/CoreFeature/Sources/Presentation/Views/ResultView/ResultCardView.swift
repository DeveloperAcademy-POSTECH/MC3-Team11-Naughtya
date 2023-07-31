import SwiftUI

public struct ResultCardView: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy
    @State private var currentIndex = 0
    @State private var cardCount = 5

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
    }

    public var body: some View {
        VStack {
            //            ScrollView(.horizontal, showsIndicators: false) {
            //                HStack(spacing: 34) {
            //                    ForEach(projectResult.abilities) { ability in
            //                        buildAbilityCardView(ability)
            //                    }
            //                }
            //                .padding(.horizontal, 36)
            //            }
            let maxLength = projectResult.abilities.count
            switch cardCount {
            case 5:
                HStack(spacing: 50 * (geometry.size.width / 1512)) {
                    ForEach(projectResult.abilities[currentIndex..<min(currentIndex + 5, maxLength)]) { ability in
                        buildAbilityCardView(ability)
                            .frame(width: 225 * (geometry.size.width / 1512), height: 269 * (geometry.size.height / 892))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.customGray8.opacity(0.5)) // TODO: figma 업데이트 필요
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if (currentIndex + cardCount) / cardCount == Int(ceil(Double(maxLength) / Double(cardCount))) && maxLength - currentIndex != 5 {
                        Spacer()
                    } else {
                        // Your code here for the else block
                    }

                }
//                .frame(minWidth: 1412)
            case 4:
                HStack(spacing: 50 * (geometry.size.width / 1214)) {
                    ForEach(projectResult.abilities[currentIndex..<min(currentIndex + 4, maxLength)]) { ability in
                        buildAbilityCardView(ability)
                            .frame(width: 225 * (geometry.size.width / 1214), height: 269 * (geometry.size.height / 892))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.customGray8.opacity(0.5)) // TODO: figma 업데이트 필요
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if (currentIndex + cardCount) / cardCount == Int(ceil(Double(maxLength) / Double(cardCount))) && maxLength - currentIndex != 4 {
                        Spacer()
                    } else {
                        // Your code here for the else block
                    }
                }
//                .frame(minWidth: 1114)
            default:
                HStack(spacing: 50 * (geometry.size.width / 920)) {
                    ForEach(projectResult.abilities[currentIndex..<min(currentIndex + 3, maxLength)]) { ability in
                        buildAbilityCardView(ability)
                            .frame(width: 225 * (geometry.size.width / 920), height: 269 * (geometry.size.height / 892))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.customGray8.opacity(0.5)) // TODO: figma 업데이트 필요
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if (currentIndex + cardCount) / cardCount == Int(ceil(Double(maxLength) / Double(cardCount))) && maxLength - currentIndex != 3 {
                        Spacer()
                    } else {
                        // Your code here for the else block
                    }
                }
//                .frame(minWidth: 820)
            }

            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        self.currentIndex -= cardCount
                        if self.currentIndex < 0 {
                            self.currentIndex = maxLength - cardCount
                        }
                    }
                }) {
                    Text("􀯷")
                        .font(
                            Font.custom("SF Pro", size: 16)
                                .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                }
                .buttonStyle(.borderless)
                Text("\((currentIndex + cardCount) / cardCount)/\(Int(ceil((Double(maxLength) / Double(cardCount)))))")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 23  * (geometry.size.width/1512))
                            .weight(.semibold)
                    )
                    .kerning(0.46)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                Button(action: {
                    withAnimation {
                        self.currentIndex += cardCount
                        if self.currentIndex >= maxLength {
                            self.currentIndex = 0
                        }
                    }
                }) {
                    Text("􀁴")
                        .font(
                            Font.custom("SF Pro", size: 16)
                                .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
                }
                .buttonStyle(.borderless)
            }
            .padding(.vertical, 27 * geometry.size.height / 892)
            //                .padding(.vertical, 55 * (geometry.size.width / 1512))
        }
        .onAppear {
            self.updateCardCount(geometry)
        }
        .onChange(of: geometry.size.width) { _ in
            self.updateCardCount(geometry)
        }

    }

    private func updateCardCount(_ geometry: GeometryProxy) {
        if geometry.size.width > 1214 {
            self.cardCount = 5
        } else if geometry.size.width <= 1214 && geometry.size.width > 920 {
            self.cardCount = 4
        } else {
            self.cardCount = 3
        }

    }

    private func buildAbilityCardView(_ ability: AbilityEntity) -> some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Text("총 \(ability.todos.count)개")
                    .foregroundColor(.pointColor)
                    .font(.system(size: 10  * (geometry.size.height / 892)))
                    .padding(.horizontal, 7  * (geometry.size.height / 892))
                    .frame(height: 16 * (geometry.size.height / 892))
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.pointColor, lineWidth: 1)
                    )
            }
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(ability.title)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 18  * (geometry.size.height / 892)))
                            .lineLimit(2)
                            .lineSpacing(14)
                        Spacer()
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 5) {
                    let colors: [Color] = [.customGray4, .customGray5, .customGray6]
                    ForEach(Array(ability.todos.enumerated()).prefix(3), id: \.offset) { todoIndex, todo in
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.square.fill")
                                .font(.system(size: 18  * (geometry.size.height / 892)))
                            Text(todo.title.value)
                                .font(.system(size: 14  * (geometry.size.height / 892)))
                                .lineLimit(1)
                        }
                        .foregroundColor(colors[todoIndex])
                    }
                }
                .padding(.top, 84 * (geometry.size.height/892))
            }
            .padding(.horizontal, 10 * (geometry.size.height / 892))
            Button {
            } label: {
                HStack {
                    Spacer()
                    Text("더보기")
                        .font(.system(size: 14  * (geometry.size.height / 892)))
                    Spacer()
                }
                .foregroundColor(.customGray2)
                .frame(height: 32 * (geometry.size.height / 892))
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.customGray6)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(
            EdgeInsets(
                top: 24 * (geometry.size.height / 892),
                leading: 20,
                bottom: 16 * (geometry.size.height / 892),
                trailing: 20
            )
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.customGray8.opacity(0.5)

                     ) // TODO: figma 업데이트 필요

        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
