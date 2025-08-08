import Foundation

public final class StreamedLogger: @unchecked Sendable {
    private let defaultCategory: LoggerCategory
    private let messageConstructor: LoggerMessageConstructor
    private let accessQueue: DispatchQueue
    private var stream: LoggerStream
    private var _logLevel: LogType

    /// Minimal log level for messages.
    @available(*, noasync)
    public var logLevel: LogType {
        get { accessQueue.sync { _logLevel } }
        set { accessQueue.sync(flags: .barrier) { _logLevel = newValue } }
    }

    public init(defaultCategory: LoggerCategory = "default", messageConstructor: LoggerMessageConstructor = .default,
                stream: LoggerStream, logLevel: LogType = .default) {
        accessQueue = DispatchQueue(label: "com.loggerkit.logger.streamed")
        self.defaultCategory = defaultCategory
        self.messageConstructor = messageConstructor
        self.stream = stream
        _logLevel = logLevel
    }

    /// Sets minimal log level of messages asynchronously.
    /// - Parameter logLevel: Minimal log level for messages.
    public func setLogLevel(_ logLevel: LogType?) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            self.accessQueue.async { [weak self] in
                defer { continuation.resume() }
                guard let self else { return }
                self._logLevel = logLevel ?? .default
            }
        }
    }

    /// Retrieves minimal log level for messages asynchronously.
    /// - Returns: Current minimal log level for messages
    public func currentLogLevel() async -> LogType {
        await withCheckedContinuation { continuation in
            self.accessQueue.async { [weak self] in
                guard let self else { return continuation.resume(returning: .default) }
                continuation.resume(returning: self._logLevel)
            }
        }
    }
}

// MARK: - LOGGER ENGINE CONFORMANCE

extension StreamedLogger: LoggerEngine {
    public func write(_ items: [Any], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int)
    {
        accessQueue.sync {
            let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                         separator: separator, terminator: terminator, file: file, line: line)
            guard let message else { return }
            guard logType.rawValue >= _logLevel.rawValue else { return }
            stream.write(message)
        }
    }

    public func writeAsync(_ items: [any Sendable], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int) async
    {
        return await withCheckedContinuation { continuation in
            self.accessQueue.async { [weak self] in
                defer { continuation.resume() }
                guard let self else { return }
                guard logType.rawValue >= _logLevel.rawValue else { return }
                let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                             separator: separator, terminator: terminator, file: file, line: line)
                guard let message else { return }
                stream.write(message)
            }
        }
    }
}
