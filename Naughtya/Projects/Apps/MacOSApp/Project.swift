import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "MacOSApp"

let project = Project(
    name: projectName,
    organizationName: Constants.organizationName,
    targets: [
        .build(
            name: projectName,
            organizationName: Constants.organizationName,
            platform: .macOS,
            product: .app,
            deploymentTarget: Constants.DeploymentTarget.macOS,
            dependencies: [
                .project(target: "MacOSCoreFeature", path: "../../Features/CoreFeature")
            ]
        )
    ]
)
