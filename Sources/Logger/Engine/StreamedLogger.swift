import Foundation

public final class StreamedLogger: LoggerEngine, @unchecked Sendable {
    private let defaultCategory: LoggerCategory
    private let messageConstructor: LoggerMessageConstructor
    private let streamLock: NSLock
    private var stream: LoggerStream

    public init(defaultCategory: LoggerCategory, messageConstructor: LoggerMessageConstructor, stream: LoggerStream) {
        self.defaultCategory = defaultCategory
        self.messageConstructor = messageConstructor
        streamLock = NSLock()
        self.stream = stream
    }

    public func write(_ items: Any..., category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int)
    {
        let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                     separator: separator, terminator: terminator, file: file, line: line)
        guard let message else { return }
        streamLock.lock()
        defer { streamLock.unlock() }
        stream.write(message)
    }
}

// MARK: - DEPRECATIONS

extension StreamedLogger {
    @available(*, deprecated, renamed: "write(_:category:logType:separator:terminator:file:line:)")
    public func write(_ message: String, of category: LoggerCategory? = nil, as logType: LogType = .default,
                      _ file: String = #fileID, _ line: Int = #line) {
        let message = messageConstructor.makeMessage(from: message, of: category ?? defaultCategory, as: logType, file, line)
        streamLock.lock()
        defer { streamLock.unlock() }
        stream.write(message + "\n")
    }
}
