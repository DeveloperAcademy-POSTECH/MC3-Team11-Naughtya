import SwiftUI

public struct ResultView: View {
    public init() {
        // Initialization code here
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {

                ResultNameView(geometry: geometry)
                HStack {
                    Divider()
                        .frame(width: 2, height: 600 * geometry.size.height / 892)
                        .overlay(.gray)
                        .padding(.trailing, 50 * (geometry.size.width / 1512))
                    VStack {

                        ResultCompleteTodoView(geometry: geometry)
                        ResultCardView(geometry: geometry)

                        HStack {
                            ResultDelayTodoView(geometry: geometry)
                            Spacer(minLength: 46 * (geometry.size.width / 1512))
                            ResultIncompleteTodoView(geometry: geometry)
                        }
                        .padding(.trailing, 30)
                        .padding(.horizontal, 0)
                    }
                }
            }
            .padding(.leading, 50)
            .padding(.top, 25)
            .frame(minWidth: 911, maxWidth: 1512, minHeight: 756, maxHeight: 892, alignment: .topLeading)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            .onAppear {
                print(geometry.size.width)
                print(geometry.size.height)
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
