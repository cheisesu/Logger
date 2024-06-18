import Testing
import XCTest
@testable import Logger

struct CountingFileRotationURLPoliticsTests {
    private let fileManager = FileManager.default

    private func handleFolder(_ folderName: String = #function, handler: (_ tempDir: URL) throws -> Void) throws {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        try handler(tempDir)
        try fileManager.removeItem(at: tempDir)
    }

    @Test(
        "When there're no files, next file url must return the same as the source one",
        .tags(.fileRotation)
    )
    func sourceFileNotExists_ReturnsSourceURL() async throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 1)
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(#function, isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: tempDir) }
        let sourceURL = tempDir.appendingPathComponent(fileName)
        let nextURL = sourceURL
        let result = politics.nextFileURL(for: sourceURL)
        try #require(result == nextURL)
    }

    @Test(
        "When there's source file, and max rotation count is zero, next file url must return the same file url",
        .tags(.fileRotation)
    )
    func sourceFileExistsAndMaxNumberIsZero_ReturnsSameURL() async throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 0)
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(#function, isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: tempDir) }
        let sourceURL = tempDir.appendingPathComponent(fileName)
        let nextURL = sourceURL
        let result = politics.nextFileURL(for: sourceURL)
        try #require(result == nextURL)
    }

    @Test(
        "When there's source file, and max rotation count is one, next file url must return the same file url appending `.1`",
        .tags(.fileRotation)
    )
    func sourceFileExistsAndMaxNumberIsOne_ReturnsURLWithNumberOne() async throws {
        let fileName = "file._tf"
        let politics: FileURLRotationPolitics = .counting(maxNumber: 1)
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(#function, isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: tempDir) }
        let sourceURL = tempDir.appendingPathComponent(fileName)
        let nextURL = sourceURL.appendingPathExtension("1")
        try Data().write(to: sourceURL)
        let result = politics.nextFileURL(for: sourceURL)
        try #require(result == nextURL)
    }
}

@available(*, deprecated)
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

    func test_NextFileURL_FileError_ReturnsNextURL() throws {
        let fileManager = _ErrorFileManager()
        let politics: FileURLRotationPolitics = CountingFileRotationURLPolitics(fileManager: fileManager, maxNumber: 1)

        try handleFolder { tempDir in
            let fileName = "file._tf"
            let sourceURL = tempDir.appendingPathComponent(fileName, isDirectory: false)
            try Data().write(to: sourceURL)
            let nextURL = tempDir.appendingPathComponent("\(fileName).1", isDirectory: false)

            let result = politics.nextFileURL(for: sourceURL)

            XCTAssertEqual(result, nextURL)
        }
    }
}
