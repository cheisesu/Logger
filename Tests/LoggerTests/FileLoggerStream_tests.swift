import XCTest
import Testing
@testable import Logger

final class FileLoggerStream_tests: XCTestCase {
    private let fileManager = FileManager.default

    override func setUpWithError() throws {
        continueAfterFailure = false
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

            _ = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, fileTransferPolicy: .counting(maxCount: 2))

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

            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, fileTransferPolicy: .counting(maxCount: 2))
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

            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: contentsSize, fileTransferPolicy: .counting(maxCount: 3))
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
            let loggerStream = try FileLoggerStream(fileURL, fileManager: fileManager, fileLimits: 0.7 * contentsSize, fileTransferPolicy: .counting(maxCount: 2))

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

    func test_100WritesSplitsCorrectlyOn5Files() throws {
        let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(#function)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: tmpDir)
        try? fileManager.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        let constructor = DefaultLoggerMessageConstructor(options: .printCategory)
        let consoleLogger: LoggerEngine = ConsoleLogger(defaultCategory: "EXAMPLE", messageConstructor: constructor)
        let fileURL = tmpDir.appending(path: "file.txt")
        let fileStream = try FileLoggerStream(fileURL, fileLimits: 3 * 1024, fileTransferPolicy: .counting(maxCount: 6))
        let fileLogger: LoggerEngine = StreamedLogger(defaultCategory: "FILE_EXAMPLE", messageConstructor: constructor, stream: fileStream)
        let logger: LoggerEngine = CombinedLogger(consoleLogger, fileLogger)

        let group = DispatchGroup()
        let count = 100
        for _ in 0..<count {
            group.enter()
        }
        DispatchQueue.concurrentPerform(iterations: count) { index in
            let wait = UInt32.random(in: 1..<3)
            logger.write("Step", index, ": logging after sleeping during", wait, "seconds",
                         "on thread", Thread.current, logType: .default)
            group.leave()
        }
        group.wait()

        let urls = try fileManager.contentsOfDirectory(at: tmpDir, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: tmpDir.path) }
        XCTAssertEqual(urls.count, 5)
        let contents = try (0..<5).flatMap { try String(contentsOf: urls[$0])
            .split(separator: "\n") }.filter { !$0.isEmpty }
        XCTAssertEqual(contents.count, count)
    }

    // MARK: - TRANSFORMING TESTS

    func test_transformingPerformed() throws {
        try handleFile { fileURL in
            let encoding = String.Encoding.utf8
            let stream = try FileLoggerStream(fileURL, encoding: encoding)
            let transformer = BlockFileStreamTransformer { Data($0.reversed()) }
            stream.addTransformer(transformer)
            let messageString = "Hello, world!"
            let resultData = Data(try XCTUnwrap(messageString.data(using: encoding)?.reversed()))

            stream.write(messageString)
            let data = try Data(contentsOf: fileURL, options: .uncached)

            XCTAssertEqual(data, resultData)
        }
    }

    func test_multipleTransformingsPerformed() throws {
        try handleFile { fileURL in
            let encoding = String.Encoding.utf8
            let stream = try FileLoggerStream(fileURL, encoding: encoding)
            let transformer1 = BlockFileStreamTransformer { Data($0.reversed()) }
            let transformer2 = BlockFileStreamTransformer { $0.base64EncodedData() }
            stream.addTransformer(transformer1)
            stream.addTransformer(transformer2)
            let messageString = "Hello, world!"
            let resultData = Data(try XCTUnwrap(messageString.data(using: encoding)?.reversed())).base64EncodedData()

            stream.write(messageString)
            let data = try Data(contentsOf: fileURL, options: .uncached)

            XCTAssertEqual(data, resultData)
        }
    }
}
