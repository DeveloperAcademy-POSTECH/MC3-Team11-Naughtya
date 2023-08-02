//
//  ProjectListHeaderView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectListHeaderView: View {
    private static let dummyDataGenerator: DummyDataGenerator = .shared
    private static let schedulingStore: SchedulingStore = .shared

    var body: some View {
        HStack {
            Text("All My Projects")
                .font(.appleSDGothicNeo(size: 14, weight: .medium))
                .foregroundColor(Color.customGray4)
            Spacer()
            Button {
                Self.dummyDataGenerator.generate()
            } label: {
                Text("dummy")
            }
            Button {
                Self.schedulingStore.managers
                    .forEach {
                        $0.tasksBatch.batchTasks()
                    }
            } label: {
                Text("result")
            }
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
    }
}

struct ProjectListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListHeaderView()
    }
}
