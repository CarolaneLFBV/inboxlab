import ProjectDescription

let project = Project(
    name: "inboxlab",
    packages: [
        .remote(
            url: "https://github.com/realm/realm-swift",
            requirement: .exact("20.0.6")
        )
    ],
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
            dependencies: [
                .package(product: "RealmSwift")
            ],
            settings: .settings(
                base: ["SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor"]
            )
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
