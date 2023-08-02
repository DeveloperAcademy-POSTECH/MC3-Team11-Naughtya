//
//  ProjectListEmptyView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectListEmptyView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("프로젝트가 없어요.")
                .multilineTextAlignment(.center)
                .font(.appleSDGothicNeo(size: 16))
                .foregroundColor(.customGray3)
            Spacer()
        }
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.customGray5)
        )
    }
}

struct ProjectListEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListEmptyView()
    }
}
