import ProjectDescription

public enum Constants {
    public static let organizationName = "Naughtya"
    
    public enum DeploymentTarget {
        public static let macOS: ProjectDescription.DeploymentTarget = .macOS(targetVersion: "13.0")
        public static let iOS: ProjectDescription.DeploymentTarget = .iOS(
            targetVersion: "16.0",
            devices: .iphone
        )
    }
}
