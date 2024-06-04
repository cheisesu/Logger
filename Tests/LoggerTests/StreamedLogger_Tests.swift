import XCTest
@testable import Logger

final class StreamedLogger_Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func test_CallsStreamWriteWithCorrectValue() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)
        let message1 = "source"
        let message2 = "message"
        let logType = LogType.error
        let file = "file"
        let line = 12
        let separator = ":"
        let terminator = "]]"
        let constructedMessage = messageContructor.makeMessage(from: message1, message2, category: category, logType: logType,
                                                               separator: separator, terminator: terminator, file: file, line: line)

        logger.write(message1, message2, category: category, logType: logType,
                     separator: separator, terminator: terminator, file: file, line: line)

        XCTAssertTrue(stream.writeCalled)
        XCTAssertEqual(stream.writeMessage, constructedMessage)
    }

    func test_NilCategory_CallsStreamWriteWithDefaultValue() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)
        let message1 = "source"
        let message2 = "message"
        let logType = LogType.error
        let file = "file"
        let line = 12
        let separator = ":"
        let terminator = "]]"
        let constructedMessage = messageContructor.makeMessage(from: message1, message2, category: category, logType: logType,
                                                               separator: separator, terminator: terminator, file: file, line: line)

        logger.write(message1, message2, category: nil, logType: logType,
                     separator: separator, terminator: terminator, file: file, line: line)

        XCTAssertTrue(stream.writeCalled)
        XCTAssertEqual(stream.writeMessage, constructedMessage)
    }

    func test_NoItems_DoesntWriteToLogger() {
        let stream = _MockedLoggerStream()
        let messageContructor: LoggerMessageConstructor = .default
        let category: LoggerCategory = "default"
        let logger = StreamedLogger(defaultCategory: category, messageConstructor: messageContructor, stream: stream)
        let logType = LogType.error
        let file = "file"
        let line = 12
        let separator = ":"
        let terminator = "]]"

        logger.write(category: category, logType: logType,
                     separator: separator, terminator: terminator, file: file, line: line)

        XCTAssertFalse(stream.writeCalled)
        XCTAssertNil(stream.writeMessage)
    }
}

// MARK: - DEPRECATIONS

extension StreamedLogger_Tests {
    @available(*, deprecated)
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

    @available(*, deprecated)
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
}
