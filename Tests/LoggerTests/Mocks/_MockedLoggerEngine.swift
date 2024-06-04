import Foundation
@testable import Logger

final class _MockedLoggerEngine: LoggerEngine, @unchecked Sendable {
    var writeCalled: Bool = false
    @available(*, deprecated)
    var writeMessage: String?
    var writeItems: [Any]?
    var writeCategory: LoggerCategory?
    var writeLogType: LogType?
    var writeFile: String?
    var writeLine: Int?
    var writeSeparator: String?
    var writeTerminator: String?

    func write(_ items: Any..., category: (any LoggerCategory)?, logType: LogType, separator: String, terminator: String, file: String, line: Int) {
        writeCalled = true
        writeItems = items
        writeCategory = category
        writeLogType = logType
        writeFile = file
        writeLine = line
        writeSeparator = separator
        writeTerminator = terminator
    }

    @available(*, deprecated)
    func write(_ message: String, of category: LoggerCategory?, as logType: LogType, _ file: String, _ line: Int) {
        writeCalled = true
        writeMessage = message
        writeCategory = category
        writeLogType = logType
        writeFile = file
        writeLine = line
    }
}
