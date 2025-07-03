import Foundation

public final class StreamedLogger: @unchecked Sendable {
    private let defaultCategory: LoggerCategory
    private let messageConstructor: LoggerMessageConstructor
    private let accessQueue: DispatchQueue
    private var stream: LoggerStream

    public init(defaultCategory: LoggerCategory = "default", messageConstructor: LoggerMessageConstructor = .default,
                stream: LoggerStream) {
        accessQueue = DispatchQueue(label: "com.loggerkit.logger.streamed")
        self.defaultCategory = defaultCategory
        self.messageConstructor = messageConstructor
        self.stream = stream
    }
}

// MARK: - LOGGER ENGINE CONFORMANCE

extension StreamedLogger: LoggerEngine {
    public func write(_ items: [Any], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int)
    {
        let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                     separator: separator, terminator: terminator, file: file, line: line)
        guard let message else { return }
        accessQueue.sync {
            stream.write(message)
        }
    }

    public func writeAsync(_ items: [any Sendable], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int) async
    {
        let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                     separator: separator, terminator: terminator, file: file, line: line)
        guard let message else { return }
        return await withCheckedContinuation { continuation in
            self.accessQueue.async { [weak self] in
                defer { continuation.resume() }
                self?.stream.write(message)
            }
        }
    }
}
