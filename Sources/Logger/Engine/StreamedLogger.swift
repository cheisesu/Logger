import Foundation

public final class StreamedLogger: LoggerEngine, @unchecked Sendable {
    private let defaultCategory: LoggerCategory
    private let messageConstructor: LoggerMessageConstructor
    private let streamLock: NSLock
    private var stream: LoggerStream

    public init(defaultCategory: LoggerCategory = "default",
                messageConstructor: LoggerMessageConstructor = .default,
                stream: LoggerStream) {
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
