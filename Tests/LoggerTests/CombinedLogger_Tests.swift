import XCTest
@testable import Logger

final class CombinedLogger_Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func test_Write_CallsAllLoggersWrite_Variadic() {
        let logger1 = _MockedLoggerEngine()
        let logger2 = _MockedLoggerEngine()
        let combined = CombinedLogger(logger1, logger2)
        let message = "message"
        let category: LoggerCategory = "category"
        let logType = LogType.error
        let line = 12
        let file = "file"

        combined.write(message, of: category, as: logType, file, line)

        [logger1, logger2].forEach { logger in
            XCTAssertTrue(logger.writeCalled)
            XCTAssertEqual(logger.writeMessage, message)
            XCTAssertEqual(logger.writeCategory?.rawLoggerCategory, category.rawLoggerCategory)
            XCTAssertEqual(logger.writeLogType, logType)
            XCTAssertEqual(logger.writeFile, file)
            XCTAssertEqual(logger.writeLine, line)
        }
    }

    func test_Write_CallsAllLoggersWrite_Array() {
        let logger1 = _MockedLoggerEngine()
        let logger2 = _MockedLoggerEngine()
        let combined = CombinedLogger([logger1, logger2])
        let message = "message"
        let category: LoggerCategory = "category"
        let logType = LogType.error
        let line = 12
        let file = "file"

        combined.write(message, of: category, as: logType, file, line)

        [logger1, logger2].forEach { logger in
            XCTAssertTrue(logger.writeCalled)
            XCTAssertEqual(logger.writeMessage, message)
            XCTAssertEqual(logger.writeCategory?.rawLoggerCategory, category.rawLoggerCategory)
            XCTAssertEqual(logger.writeLogType, logType)
            XCTAssertEqual(logger.writeFile, file)
            XCTAssertEqual(logger.writeLine, line)
        }
    }
}
