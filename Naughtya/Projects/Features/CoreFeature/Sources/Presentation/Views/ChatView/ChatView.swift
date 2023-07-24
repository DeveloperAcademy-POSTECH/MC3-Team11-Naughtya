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
//            HStack {
//
//                TextField("enter a message", text: $viewModel.currentInput) {
//
//                }
//                    .padding()
//                    .background(.gray.opacity(0.1))
//                    .cornerRadius(12)
//                Button {
//                    viewModel.sendMessage()
//
//                } label: {
//                    Text("Send")
//                        .padding()
//                        .background(.black)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//
//            }
//            Button {
//                dismiss()
//            } label: {
//                Text("나가기")
//            }

        }
        .padding()
//        .onAppear{
//            openAIService.sendMessage(message: "Generate a tagline for an ice cream shop")
//        }

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

            if message.role == .assistant {

            }
        }
    }

}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
