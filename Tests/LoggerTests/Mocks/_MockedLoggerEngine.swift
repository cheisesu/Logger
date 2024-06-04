import Foundation
@testable import Logger

final class _MockedLoggerEngine: LoggerEngine, @unchecked Sendable {
    var writeCalled: Bool = false
    var writeMessage: String?
    var writeCategory: LoggerCategory?
    var writeLogType: LogType?
    var writeFile: String?
    var writeLine: Int?

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
