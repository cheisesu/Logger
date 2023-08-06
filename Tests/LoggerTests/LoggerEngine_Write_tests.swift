import XCTest
@testable import Logger

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
