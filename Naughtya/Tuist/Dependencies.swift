import ProjectDescription

let dependencies = Dependencies(
    carthage: [
    ],
    swiftPackageManager: [
        .remote(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", requirement: .upToNextMajor(from: "2.2.3"))
    ],
    platforms: [.iOS, .macOS]
)
