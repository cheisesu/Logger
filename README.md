# LoggerKit

![Build][BuildStatusBadge]
[![Documentation][DocumentationBadge]][DocumentationLink]
[![Swift6 compatible][Swift6Badge]][SwiftLink]
![Supported platforms][PlatformsBadge]
![Swift Package Manager][SPMBadge]
![License][LicenseBadge]
![GitHub Release][GitHubReleaseBadge]

A type-safe, customizable and extendable logging library.

## Features

TODO:

## Requirements

- Swift 6+
- iOS 13.0+
- tvOS 13.0+
- macOS 10.15+
- Xcode 16.0+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager) is a tool for managing the distribution of Swift code.

1. Add the following to your `Package.swift` file:

   ```
   dependencies: [
       .package(url: "https://github.com/cheisesu/Logger.git", from: "0.1.1"),
   ]
   ```

1. Add the dependency to your target:

   ```
   .target(
       name: "YourTarget",
       dependencies: [
           .product(name: "Logger", package: "Logger")
       ]
   )
   ```

## Usage

TODO:

## Links

- [Documentation][DocumentationLink]
- TODO: Example

## Author

Dmitrii Shelonin, [cheisesu@gmail.com](mailto:cheisesu@gmail.com)

## License

`Logger` is available under the MIT license. See [the LICENSE file](LICENSE) for more information.

[BuildStatusBadge]: https://img.shields.io/github/actions/workflow/status/cheisesu/Logger/pr-test.yml?branch=master&style=flat-square&label=Build&labelColor=gray
[SwiftLink]: https://developer.apple.com/swift/
[Swift6Badge]: https://img.shields.io/badge/Swift-6-F05138?style=flat-square&label=Swift&labelColor=gray&color=F05138
[GitHubReleaseBadge]: https://img.shields.io/github/v/release/cheisesu/Logger?style=flat-square&labelColor=gray&color=blue&label=Release
[LicenseBadge]: https://img.shields.io/github/license/cheisesu/Logger?style=flat-square&labelColor=gray&label=License
[PlatformsBadge]: https://img.shields.io/badge/Platforms-iOS%7CtvOS%7CmacOS%7CLinux-999?style=flat-square&labelColor=gray
[DocumentationBadge]: https://img.shields.io/github/actions/workflow/status/cheisesu/Logger/docc.yml?branch=13-add-deploying-documentation&style=flat-square&label=Docs&labelColor=gray
[DocumentationLink]: https://cheisesu.github.io/Logger/documentation/logger
[SPMBadge]: https://img.shields.io/badge/SPM-Compatible-F05138?style=flat-square&label=SPM&labelColor=gray&color=F05138
