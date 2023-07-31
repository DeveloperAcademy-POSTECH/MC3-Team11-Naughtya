import SwiftUI

public struct ResultCardView: View {
    let geometry: GeometryProxy
    @State private var currentIndex = 0
    private let items = [Int](1...500)
    @State private var cardCount = 5

    public init(geometry: GeometryProxy) {
        self.geometry = geometry

    }

    public var body: some View {

        VStack {

            switch cardCount {
            case 5: HStack(spacing: 50 * (geometry.size.width / 1512)) {
                ForEach(items[currentIndex..<currentIndex + 5], id: \.self) { item in

                        Text("\(item)")
                            .frame(width: 225 * (geometry.size.width / 1512), height: 269 * (geometry.size.height / 892))
                            .background(Color.black)

                }
            }
            case 4: HStack(spacing: 50 * (geometry.size.width / 1512)) {
                ForEach(items[currentIndex..<currentIndex + 4], id: \.self) { item in

                        Text("\(item)")
                            .frame(width: 225 * (geometry.size.width / 1214), height: 269 * (geometry.size.height / 892))
                            .background(Color.black)

                }
            }
            default:
                HStack(spacing: 50 * (geometry.size.width / 1512)) {
                    ForEach(items[currentIndex..<currentIndex + 3], id: \.self) { item in

                            Text("\(item)")
                                .frame(width: 225 * (geometry.size.width / 920), height: 269 * (geometry.size.height / 892))
                                .background(Color.black)

                    }
                }            }

//            .padding(.horizontal, (geometry.size.width / 1512))
//            .frame(maxWidth: 1325)

                HStack(alignment: .center, spacing: 8) {
                    Button(action: {
                        withAnimation {
                            self.currentIndex -= cardCount
                            if self.currentIndex < 0 {
                                self.currentIndex = self.items.count - cardCount
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
                    Text("\((currentIndex + cardCount) / cardCount)/\(items.count / cardCount)")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 23)
                                .weight(.semibold)
                        )
                        .kerning(0.46)
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    Button(action: {
                        withAnimation {
                            self.currentIndex += cardCount
                            if self.currentIndex >= self.items.count {
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
    }
