import SwiftUI

public struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
//    @Environment(\.dismiss) private var dismiss

    public init() {
    }
    public var body: some View {

        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                        messageView(message: message)
                    }

                }
                .padding()

            }
            .onAppear {
                viewModel.sendMessage()
            }

        }
        .padding()

    }
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
            } else {
                Text(message.content)
                    .foregroundColor(message.role == .user ? .black : .white)
                    .padding()
                    .background(message.role == .assistant ? .blue : .gray.opacity(0.1))
                    .cornerRadius(16)
            }

        }
    }

}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
