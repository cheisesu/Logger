import XCTest
@testable import Logger

final class LoggerEngine_Write_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_ExtendedWriteItems_CallesSourceWriteWithCorrectArguments() throws {
        let engine = _MockedLoggerEngine()
        let file = #fileID

        let line = #line; engine.write("source", "message", category: "category")

        XCTAssertTrue(engine.writeCalled)
        XCTAssertEqual(engine.writeItems?.map { String(describing: $0) }, ["source", "message"])
        XCTAssertEqual(engine.writeCategory?.rawLoggerCategory, "category")
        XCTAssertEqual(engine.writeLogType, .default)
        XCTAssertEqual(engine.writeFile, file)
        XCTAssertEqual(engine.writeLine, line)
    }
}
