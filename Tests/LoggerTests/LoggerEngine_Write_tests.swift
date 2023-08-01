import XCTest
@testable import Logger

private final class _MockedLoggerEngine: LoggerEngine {
    var flushCalled: Bool = false
    var writeCalled: Bool = false
    var writeMessage: String?
    var writeCategory: LoggerCategory?
    var writeLogType: LogType?
    var writeFile: String?
    var writeLine: Int?

    func write(_ message: String, of category: LoggerCategory?, as logType: LogType, _ file: String, _ line: Int) {
        writeCalled = true
        writeMessage = message
        writeCategory = category
        writeLogType = logType
        writeFile = file
        writeLine = line
    }

    func flush() {
        flushCalled = true
    }
}

final class LoggerEngine_Write_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_ExtendedWrite_PassingLogType_CallesSourceWriteWithCorrectArguments() {
        let engine = _MockedLoggerEngine()
        let file = #fileID

        let line = #line; engine.write("message", of: "category", as: .fault)

        XCTAssertTrue(engine.writeCalled)
        XCTAssertEqual(engine.writeMessage, "message")
        XCTAssertEqual(engine.writeCategory?.rawLoggerCategory, "category")
        XCTAssertEqual(engine.writeLogType, .fault)
        XCTAssertEqual(engine.writeFile, file)
        XCTAssertEqual(engine.writeLine, line)
    }

    func test_ExtendedWrite_DefaultLogType_CallesSourceWriteWithCorrectArguments() {
        let engine = _MockedLoggerEngine()
        let file = #fileID

        let line = #line; engine.write("message", of: "category")

        XCTAssertTrue(engine.writeCalled)
        XCTAssertEqual(engine.writeMessage, "message")
        XCTAssertEqual(engine.writeCategory?.rawLoggerCategory, "category")
        XCTAssertEqual(engine.writeLogType, .default)
        XCTAssertEqual(engine.writeFile, file)
        XCTAssertEqual(engine.writeLine, line)
    }
}
