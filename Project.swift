import ProjectDescription

let project = Project(
    name: "inboxlab",
    packages: [
        .remote(
            url: "https://github.com/realm/realm-swift",
            requirement: .exact("20.0.6")
        ),
        .remote(
            url: "https://github.com/Alamofire/Alamofire",
            requirement: .exact("5.12.2")
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
                "inboxlab/Sources/Core",
                "inboxlab/Resources",
            ],
            dependencies: [
                .package(product: "RealmSwift", type: .runtimeEmbedded),
                .package(product: "Alamofire"),
                .target(name: "InboxDomain"),
                .target(name: "InboxData"),
                .target(name: "InboxPresentation")
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
            dependencies: [
                .target(name: "inboxlab"),
                .target(name: "InboxData"),
                .target(name: "InboxDomain"),
                .target(name: "InboxPresentation"),
                .package(product: "RealmSwift"),
                .package(product: "Alamofire")
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited) -framework RealmSwift",
                    "FRAMEWORK_SEARCH_PATHS": "$(inherited) $(BUILT_PRODUCTS_DIR)/PackageFrameworks"
                ]
            )
        ),
        .target(
            name: "InboxDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.inboxlab.domain",
            deploymentTargets: .iOS("18.0"),
            buildableFolders: [
                "inboxlab/Sources/Features/Inbox/Domain"
            ]
        ),
        .target(
            name: "InboxData",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.inboxlab.data",
            deploymentTargets: .iOS("18.0"),
            buildableFolders: [
                "inboxlab/Sources/Features/Inbox/Data"
            ],
            dependencies: [
                .target(name: "InboxDomain"),
                .package(product: "RealmSwift"),
                .package(product: "Alamofire")
            ],
            settings: .settings(
                base: ["SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor"]
            )
        ),
        .target(
            name: "InboxPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.inboxlab.presentation",
            deploymentTargets: .iOS("18.0"),
            buildableFolders: [
                "inboxlab/Sources/Features/Inbox/Presentation",
            ],
            dependencies: [
                .target(name: "InboxDomain"),
            ],
            settings: .settings(
                base: ["SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor"]
            )
        ),
    ]
)
