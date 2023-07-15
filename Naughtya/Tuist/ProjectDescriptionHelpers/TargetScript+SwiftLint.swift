import Foundation
import ProjectDescription

extension TargetScript {
    public static var swiftlint: Self {
        .pre(
            script: """
            ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
            ${ROOT_DIR}/swiftlint --fix
            """,
            name: "SwiftLint",
            basedOnDependencyAnalysis: false
        )
    }
}
