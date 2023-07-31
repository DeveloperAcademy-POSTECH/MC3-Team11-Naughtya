import SwiftUI

public struct ResultView: View {
    public let projectResult: ProjectResultModel

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if projectResult.isGenerated {
                    VStack(spacing: 0) {
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
                                HStack(alignment: .center, spacing: 80) {
                                    ResultDelayTodoView(
                                        projectResult: projectResult,
                                        geometry: geometry
                                    )
                                    Spacer(minLength: 80 * (geometry.size.width / 1512))
                                    ResultIncompleteTodoView(
                                        projectResult: projectResult,
                                        geometry: geometry
                                    )
                                }
                                .padding(.vertical, 30)
                                .padding(.horizontal, 30)
                            }
                        }
                    }
                    .padding(.leading, 50)
                    .padding(.bottom, 95)
                    .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                } else {
                    emptyView
                }
            }
            .padding(.leading, 50)
            .padding(.top, 35 * geometry.size.height / 892)
            .padding(.trailing, 70)
            .frame(minWidth: 911, maxWidth: 1512, minHeight: 756, maxHeight: 892, alignment: .topLeading)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
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
}

// struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(projectResult: .from(entity: ProjectResultEntity.sample))
//    }
// }
