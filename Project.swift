import ProjectDescription

let project = Project(
    name: "XCur",
    targets: [
        .target(
            name: "XCur",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.XCur",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["XCur/Sources/**"],
            resources: ["XCur/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "XCurTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.XCurTests",
            infoPlist: .default,
            sources: ["XCur/Tests/**"],
            resources: [],
            dependencies: [.target(name: "XCur")]
        ),
    ]
)
