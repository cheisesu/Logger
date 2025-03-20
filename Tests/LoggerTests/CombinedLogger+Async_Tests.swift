import Testing
import Foundation
@testable import Logger

extension Tag {
    @Tag
    static var combinedLogger: Self
}

struct CombinedLogger_Async_Tests {
    private let message1 = "source"
    private let message2 = "message"
    private let category: LoggerCategory = "category"
    private let logType = LogType.error
    private let line = 12
    private let file = "file"
    private let separator = ":"
    private let terminator = "]]"

    @Test(
        "When calling `write`, all parameters will be passed to each logger when initialized with non-array values.",
        .tags(.combinedLogger)
    )
    func write_ParametersArePassedToEachLogger_NonArray() async throws {
        let logger1 = _MockedLoggerEngine()
        let logger2 = _MockedLoggerEngine()
        let combined = CombinedLogger.Async(logger1, logger2)

        await combined.write(message1, message2, category: category, logType: logType,
                             separator: separator, terminator: terminator, file: file, line: line)

        try [logger1, logger2].forEach { logger in
            try #require(logger.writeCalled)
            let source = [message1, message2]
            let test = logger.writeItems?.map { String(describing: $0) }
            try #require(test == source)
            try #require(logger.writeCategory?.rawLoggerCategory == category.rawLoggerCategory)
            try #require(logger.writeLogType == logType)
            try #require(logger.writeFile == file)
            try #require(logger.writeLine == line)
        }
    }

    @Test("When calling `write`, all parameters will be passed to each logger when initialized with array values.")
    func write_ParametersArePassedToEachLogger_Array() async throws {
        let logger1 = _MockedLoggerEngine()
        let logger2 = _MockedLoggerEngine()
        let combined = CombinedLogger.Async([logger1, logger2])

        await combined.write(message1, message2, category: category, logType: logType,
                             separator: separator, terminator: terminator, file: file, line: line)

        try [logger1, logger2].forEach { logger in
            try #require(logger.writeCalled)
            let source = [message1, message2]
            let test = logger.writeItems?.map { String(describing: $0) }
            try #require(test == source)
            try #require(logger.writeCategory?.rawLoggerCategory == category.rawLoggerCategory)
            try #require(logger.writeLogType == logType)
            try #require(logger.writeFile == file)
            try #require(logger.writeLine == line)
        }
    }
}
