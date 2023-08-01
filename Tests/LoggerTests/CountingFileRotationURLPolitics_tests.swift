import XCTest
@testable import Logger

final class CountingFileRotationURLPolitics_tests: XCTestCase {
    private let fileManager = FileManager.default

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    private func handleFolder(_ folderName: String = #function, handler: (_ tempDir: URL) throws -> Void) throws {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        try handler(tempDir)
        try fileManager.removeItem(at: tempDir)
    }

    func test_NextFileURL_NoFiles_ReturnsSourceURL() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 1)

        try handleFolder { tempDir in
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)

            let nextURL = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(nextURL, sourceURL)
        }
    }

    func test_NextFileURL_SourceExists_ReturnsSourceURLWithNumberOne() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 1)

        try handleFolder { tempDir in
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)
            try Data().write(to: sourceURL)
            let nextURL = tempDir.appendingPathComponent("\(fileName).1", isDirectory: false)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, nextURL)
        }
    }

    func test_NextFileURL_OneExists_MaxTwo_ReturnsSourceURLWithNumberTwo() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 2)

        try handleFolder { tempDir in
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)
            try Data().write(to: sourceURL)
            var nextURL = tempDir.appendingPathComponent("\(fileName).1", isDirectory: false)
            try Data().write(to: nextURL)
            nextURL = tempDir.appendingPathComponent("\(fileName).2", isDirectory: false)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, nextURL)
        }
    }

    func test_NextFileURL_TwoExists_MaxTwo_ReturnsSourceURLWithNumberTwo() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 2)

        try handleFolder { tempDir in
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)
            try Data().write(to: sourceURL)
            var nextURL = tempDir.appendingPathComponent("\(fileName).1", isDirectory: false)
            try Data().write(to: nextURL)
            nextURL = tempDir.appendingPathComponent("\(fileName).2", isDirectory: false)
            try Data().write(to: nextURL)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, nextURL)
        }
    }

    func test_NextFileURL_TwoExists_MaxZero_ReturnsSourceURL() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 0)

        try handleFolder { tempDir in
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)
            try Data().write(to: sourceURL)
            var nextURL = tempDir.appendingPathComponent("\(fileName).1", isDirectory: false)
            try Data().write(to: nextURL)
            nextURL = tempDir.appendingPathComponent("\(fileName).2", isDirectory: false)
            try Data().write(to: nextURL)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, sourceURL)
        }
    }

    func test_NextFileURL_WrongURL_ReturnsSourceURL() throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 0)

        try handleFolder { tempDir in
            let tempDir = tempDir.appendingPathComponent("bad", isDirectory: true)
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, sourceURL)
        }
    }
}
