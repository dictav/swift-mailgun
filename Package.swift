import PackageDescription

let package = Package(
    name: "Mailgun",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", majorVersion:3)
    ]
)
