//
//  SearchView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct SearchView: View {
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    @StateObject private var viewModel = SearchViewModel()

    public init() {
    }

    public var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "magnifyingglass")
                .font(.appleSDGothicNeo(size: 13))
                .foregroundColor(.customGray4)
            TextField(text: $viewModel.searchedText) {
                Text("프로젝트 할 일을 검색해봐요.")
                    .foregroundColor(.customGray1)
            }
            .textFieldStyle(.plain)
            .font(.appleSDGothicNeo(size: 12))
            .onExitCommand {
                viewModel.searchedText = ""
            }
        }
        .padding(.horizontal, 7)
        .frame(width: 222, height: 27)
        .overlay(
            Group {
                if viewModel.isSearching {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.pointColor, lineWidth: 2)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.customGray4, lineWidth: 1)
                }
            }
        )
        .animation(.easeOut, value: viewModel.isSearching)
        .onChange(of: viewModel.searchedText) {
            viewModel.searchGlobally(text: $0)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
