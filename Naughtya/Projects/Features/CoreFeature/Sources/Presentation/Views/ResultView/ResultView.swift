import SwiftUI

public struct ResultView: View {
    public let projectResult: ProjectResultModel
    @State private var pageNum: Int = 1

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult

    }

//    public let projectResult: ProjectResultModel
//    private let geometry: GeometryProxy
//    private let ability: AbilityEntity
//    @State private var pageNum: Int = 1
//
//    public init(
//        projectResult: ProjectResultModel,
//        geometry: GeometryProxy,
//        ability: AbilityEntity
//    ) {
//        self.projectResult = projectResult
//        self.geometry = geometry
//        self.ability = ability
//    }

    public var body: some View {

        switch pageNum {
        case 1: GeometryReader { geometry in
            if projectResult.isGenerated {
                VStack {
                    ResultNameView(projectResult: projectResult,
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
                                geometry: geometry,
                                pageNum: $pageNum
                            )
                            ResultCardView(
                                projectResult: projectResult,
                                geometry: geometry,
                                pageNum: $pageNum
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
                .background(MacOSCoreFeatureAsset.bbback.swiftUIImage.resizable().aspectRatio(contentMode: .fill))

            } else {
                emptyView

                    .frame(minHeight: 756, maxHeight: .infinity, alignment: .topLeading)

            }
        }
        default: GeometryReader { geometry in
            ProjectResultDetailView(projectResult: projectResult, geometry: geometry)

        }

        }

//        }

                }
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
