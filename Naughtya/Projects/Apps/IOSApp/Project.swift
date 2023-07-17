import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "IOSApp"

let project = Project(
    name: projectName,
    organizationName: Constants.organizationName,
    targets: [
        .build(
            name: projectName,
            organizationName: Constants.organizationName,
            platform: .iOS,
            product: .app,
            deploymentTarget: Constants.DeploymentTarget.iOS,
            dependencies: [
                .project(target: "IOSCoreFeature", path: "../../Features/CoreFeature")
            ]
        )
    ]
)
