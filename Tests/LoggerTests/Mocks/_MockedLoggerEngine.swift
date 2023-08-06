import Foundation
@testable import Logger

final class _MockedLoggerEngine: LoggerEngine {
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
