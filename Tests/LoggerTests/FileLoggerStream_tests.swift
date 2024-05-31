import XCTest
@testable import Logger

final class FileLoggerStream_tests: XCTestCase {
    private let fileManager = FileManager.default

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    private func handleFile(_ fileName: String = #function, handler: (_ fileURL: URL) throws -> Void) throws {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = tempDir.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: fileURL)
        try handler(fileURL)
        try fileManager.removeItem(at: fileURL)
    }

    // MARK: - WITHOUT ROTATION POLITICS

    func test_SourceFileExists_Write_AppendsToEnd() throws {
        try handleFile { fileURL in
            let initialContent = "Initial content\n"
            let additionalContent = "Additional content\n"
            try initialContent.write(to: fileURL, atomically: true, encoding: .utf8)

            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager)
            loggerStream.write(additionalContent)
            let loadedContent = try String(contentsOf: fileURL, encoding: .utf8)

            XCTAssertEqual(loadedContent, initialContent + additionalContent)
        }
    }

    func test_SourceFileNotExist_CreatesFile() throws {
        try handleFile { fileURL in
            _ = try FileLoggerStream(fileURL, fileManager: fileManager)

            _ = try String(contentsOf: fileURL, encoding: .utf8)
            let exists = fileManager.fileExists(atPath: fileURL.path)

            XCTAssertTrue(exists)
        }
    }

    func test_ConcurrentWrite_NoRotation_WrittenFullContent() throws {
        try handleFile { fileURL in
            let count = 500
            let contents: [String] = (0..<count).map { "this is a test line \($0)\n" }
            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager)

            let group = DispatchGroup()
            (0..<count).forEach { _ in group.enter() }
            DispatchQueue.concurrentPerform(iterations: count) { index in
                let line = contents[index]
                loggerStream.write(line)
                group.leave()
            }
            let waitResult = group.wait(timeout: .now() + 5)
            XCTAssertEqual(waitResult, .success)
            let loadedContent = try String(contentsOf: fileURL, encoding: .utf8)
            let loadedContentArray = loadedContent.split(separator: "\n").map { String($0) + "\n" }
            XCTAssertEqual(Set(loadedContentArray), Set(contents))
        }
    }

    // MARK: - WITH ROTATION POLITICS

    func test_ChangeFile_MaxSizeReached_CreatesNextFile() throws {
        try handleFile { fileURL in
            let count = 200
            let contents: [String] = (0..<count).map { "this is a test line \($0)\n" }
            let contentsString = contents.joined()
            let contentsSize = contentsString.utf8.count
            try contentsString.write(to: fileURL, atomically: true, encoding: .utf8)
            let nextURL = fileURL.appendingPathExtension("1")

            try? fileManager.removeItem(at: nextURL)
            var exists = fileManager.fileExists(atPath: nextURL.path)
            XCTAssertFalse(exists)

            _ = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, rotationURLPolitics: .counting(maxNumber: 1))

            exists = fileManager.fileExists(atPath: nextURL.path)
            XCTAssertTrue(exists)
        }
    }

    func test_ChangeFile_MaxSizeReached_WritesToNextFile() throws {
        try handleFile { fileURL in
            let count = 200
            let contents: [String] = (0..<count).map { "this is a test line \($0)\n" }
            let contentsString = contents.joined()
            let contentsSize = contentsString.utf8.count
            let nextURL = fileURL.appendingPathExtension("1")
            try contentsString.write(to: fileURL, atomically: true, encoding: .utf8)

            try? fileManager.removeItem(at: nextURL)
            var exists = fileManager.fileExists(atPath: nextURL.path)
            XCTAssertFalse(exists)

            let newContent = "That's a new content\n"

            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, rotationURLPolitics: .counting(maxNumber: 1))
            loggerStream.write(newContent)

            exists = fileManager.fileExists(atPath: nextURL.path)
            XCTAssertTrue(exists)

            let loadedContent = try String(contentsOf: fileURL, encoding: .utf8)
            XCTAssertEqual(loadedContent, newContent)
        }
    }

    func test_ChangeFile_MaxSizeReached_AllFiles_WritesToNextCorrectFile() throws {
        try handleFile { fileURL in
            let range1 = 0..<100
            let range2 = 100..<200
            let range3 = 200..<300
            let contents1: [String] = range1.map { "this is a test line \($0)\n" }
            let contents2: [String] = range2.map { "this is a test line \($0)\n" }
            let contents3: [String] = range3.map { "this is a test line \($0)\n" }
            let nextURL1 = fileURL.appendingPathExtension("1")
            let nextURL2 = fileURL.appendingPathExtension("2")

            try contents1.joined().write(to: fileURL, atomically: true, encoding: .utf8)
            try contents2.joined().write(to: nextURL1, atomically: true, encoding: .utf8)
            try contents3.joined().write(to: nextURL2, atomically: true, encoding: .utf8)

            let contentsSize = contents1.joined().utf8.count
            let newContent = "That's a new content\n"

            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, rotationURLPolitics: .counting(maxNumber: 2))
            loggerStream.write(newContent)

            XCTAssertTrue(fileManager.fileExists(atPath: nextURL2.path))

            let loadedContent = try String(contentsOf: fileURL, encoding: .utf8)
            XCTAssertEqual(loadedContent, newContent)
        }
    }

    func test_ConcurrentWrite_Rotation_WrittenFullContent() throws {
        try handleFile { fileURL in
            let count = 500
            let contents: [String] = (0..<count).map { "this is a test line \($0)\n" }
            let contentsString = contents.joined()
            let contentsSize = Double(contentsString.utf8.count)
            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: 0.7 * contentsSize, rotationURLPolitics: .counting(maxNumber: 1))

            DispatchQueue.concurrentPerform(iterations: count) { index in
                let line = contents[index]
                loggerStream.write(line)
            }
            let loadedContent1 = try String(contentsOf: fileURL, encoding: .utf8)
            let nextFile = fileURL.appendingPathExtension("1")
            let loadedContent2 = try String(contentsOf: nextFile, encoding: .utf8)
            let loadedContentArray = (loadedContent1 + loadedContent2).split(separator: "\n").map { String($0) + "\n" }
            XCTAssertEqual(Set(loadedContentArray), Set(contents))
        }
    }
}
