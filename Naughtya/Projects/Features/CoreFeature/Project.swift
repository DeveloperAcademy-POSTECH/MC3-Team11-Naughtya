import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "CoreFeature"

let project = Project(
    name: projectName,
    organizationName: Constants.organizationName,
    targets: [
        .build(
            name: "MacOS" + projectName,
            organizationName: Constants.organizationName,
            platform: .macOS,
            product: .framework,
            deploymentTarget: Constants.DeploymentTarget.macOS
        ),
        .build(
            name: "IOS" + projectName,
            organizationName: Constants.organizationName,
            platform: .iOS,
            product: .framework,
            deploymentTarget: Constants.DeploymentTarget.iOS
        )
    ]
)
