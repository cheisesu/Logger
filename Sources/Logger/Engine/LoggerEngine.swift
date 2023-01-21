import Foundation

public protocol LoggerEngine {
    func write(group: LoggerCategory?, _ message: String, logType: LogType, _ file: String, _ line: Int)
    func write(group: LoggerCategory?, _ message: String, logType: LogType, _ file: String, _ line: Int) async

    func flush()
    func flush() async
}

extension LoggerEngine {
    public func write(group: LoggerCategory? = nil, _ message: String, logType: LogType, _ file: String = #filePath, _ line: Int = #line) {
        write(group: group, message, logType: logType, file, line)
    }

    public func write(group: LoggerCategory? = nil, _ message: String, _ file: String = #filePath, _ line: Int = #line) {
        write(group: group, message, logType: .default, file, line)
    }

    public func write(group: LoggerCategory? = nil, _ message: String, logType: LogType, _ file: String = #filePath, _ line: Int = #line) async {
        await write(group: group, message, logType: logType, file, line)
    }

    public func write(group: LoggerCategory? = nil, _ message: String, _ file: String = #filePath, _ line: Int = #line) async {
        await write(group: group, message, logType: .default, file, line)
    }
}
