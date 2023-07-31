import SwiftUI

public struct ResultView: View {
    public let projectResult: ProjectResultModel

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        GeometryReader { geometry in

            if projectResult.isGenerated {
                VStack {
                    ResultNameView(
                        projectResult: projectResult,
                        geometry: geometry
                    )
                    HStack {
                        Divider()
                            .frame(width: 2, height: 635 * geometry.size.height / 892)
                            .overlay(.gray)
                            .padding(.trailing, 50 * (geometry.size.width / 1512))
                        VStack {
                            ResultCompleteTodoView(
                                projectResult: projectResult,
                                geometry: geometry
                            )
                            ResultCardView(
                                projectResult: projectResult,
                                geometry: geometry
                            )
                            HStack(spacing: 80 * (geometry.size.width / 1512)) {
                                ResultDelayTodoView(
                                    projectResult: projectResult,
                                    geometry: geometry
                                )
                                //                                    Spacer(minLength: 80 * (geometry.size.width / 1512))
                                ResultIncompleteTodoView(
                                    projectResult: projectResult,
                                    geometry: geometry
                                )
                            }
                        }
                    }

                }

                .padding(.leading, 50)
                .padding(.top, 35 * geometry.size.height / 892)
                .padding(.trailing, 70)
                .frame(minHeight: 756, maxHeight: .infinity, alignment: .topLeading)

            } else {
                emptyView
                    .background(MacOSCoreFeatureAsset.back.swiftUIImage)
            }
        }
        .background(MacOSCoreFeatureAsset.back.swiftUIImage)

    }

    private var emptyView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("리포트 생성중 🙂")
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
    }
}

// struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(projectResult: .from(entity: ProjectResultEntity.sample))
//    }
// }
