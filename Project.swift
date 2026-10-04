import ProjectDescription

let project = Project(
    name: "inboxlab",
    targets: [
        .target(
            name: "inboxlab",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.inboxlab",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "inboxlab/Sources",
                "inboxlab/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "inboxlabTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.inboxlabTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            buildableFolders: [
                "inboxlab/Tests"
            ],
            dependencies: [.target(name: "inboxlab")]
        ),
    ]
)
