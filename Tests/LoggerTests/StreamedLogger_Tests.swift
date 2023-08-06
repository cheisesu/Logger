import XCTest
@testable import Logger

final class StreamedLogger_Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func test_Write_CallesStreamWriteWithCorrectValue() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)
        let message = "a message"
        let logType = LogType.error
        let file = "file"
        let line = 12
        let constructedMessage = messageContructor.makeMessage(from: message, of: category, as: logType, file, line) + "\n"

        logger.write(message, of: category, as: logType, file, line)

        XCTAssertTrue(stream.writeCalled)
        XCTAssertEqual(stream.writeMessage, constructedMessage)
    }

    func test_Write_NilCategory_CallesStreamWriteWithCorrectValue() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)
        let message = "a message"
        let logType = LogType.error
        let file = "file"
        let line = 12
        let constructedMessage = messageContructor.makeMessage(from: message, of: category, as: logType, file, line) + "\n"

        logger.write(message, of: nil, as: logType, file, line)

        XCTAssertTrue(stream.writeCalled)
        XCTAssertEqual(stream.writeMessage, constructedMessage)
    }

    func test_Flush_CallesStreamFlush() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)

        logger.flush()

        XCTAssertTrue(stream.flushCalled)
    }
}
