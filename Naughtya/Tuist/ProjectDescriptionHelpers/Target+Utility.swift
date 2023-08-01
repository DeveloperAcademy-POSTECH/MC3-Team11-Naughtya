//
//  Target+Utility.swift
//  ProjectDescriptionHelpers
//
//  Created by byo on 2023/07/15.
//

import ProjectDescription

extension Target {
    public static func build(
        name: String,
        organizationName: String,
        platform: Platform,
        product: Product,
        deploymentTarget: DeploymentTarget? = nil,
        hasResources: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Self {
        Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            sources: ["Sources/**"],
            resources: hasResources ? ["Resources/**"] : nil,
            scripts: [.swiftlint],
            dependencies: dependencies
        )
    }
}
