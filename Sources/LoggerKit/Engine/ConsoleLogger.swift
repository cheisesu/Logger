import Foundation
#if canImport(os)
import os

/// Logger engine of system console.
///
/// This engine writes messages to the system log, that you can see in Console.app.
public final class ConsoleLogger: @unchecked Sendable {
    private let accessQueue: DispatchQueue
    private var osLogs: [String: OSLog]
    private let defaultCategory: LoggerCategory
    private let subsystem: String
    private let messageConstructor: LoggerMessageConstructor

    /// Initializes console logger engine.
    /// - Parameters:
    ///   - subsystem: Identifier of the app which is used in Console.app. Default value is bundle identifier or `logger.box.console`
    ///   - defaultCategory: Default category for messages. Default value is `default`
    ///   - messageConstructor: Construct of final messages from several arguments. Default value is <doc:LoggerMessageConstructor/default>
    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "logger.box.console",
                defaultCategory: LoggerCategory = "default",
                messageConstructor: LoggerMessageConstructor = .default)
    {
        accessQueue = DispatchQueue(label: "com.loggerkit.logger.console")
        self.subsystem = subsystem
        self.defaultCategory = defaultCategory
        osLogs = [
            defaultCategory.rawLoggerCategory: OSLog(subsystem: subsystem, category: defaultCategory.rawLoggerCategory)
        ]
        self.messageConstructor = messageConstructor
    }
}

// MARK: - LOGGER ENGINE CONFIRMANCE

extension ConsoleLogger: LoggerEngine {
    public func write(_ items: [Any], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int)
    {
        accessQueue.sync {
            let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                         separator: separator, terminator: terminator, file: file, line: line)
            guard let message else { return }
            let osLog = osLog(for: category)
            os_log("%{public}@", log: osLog, type: logType.osLogType, message)
        }
    }

    public func writeAsync(_ items: [any Sendable], category: (any LoggerCategory)?, logType: LogType,
                           separator: String, terminator: String, file: String, line: Int) async
    {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            self.accessQueue.async { [weak self] in
                defer { continuation.resume() }
                guard let self else { return }
                let message = messageConstructor.makeMessage(from: items, category: category ?? defaultCategory, logType: logType,
                                                             separator: separator, terminator: terminator, file: file, line: line)
                guard let message else { return }
                let osLog = osLog(for: category)
                os_log("%{public}@", log: osLog, type: logType.osLogType, message)
            }
        }
    }
}

// MARK: - PRIVATE METHODS

extension ConsoleLogger {
    private func osLog(for group: LoggerCategory?) -> OSLog {
        let group = group ?? defaultCategory
        if let log = osLogs[group.rawLoggerCategory] {
            return log
        }
        let osLog = OSLog(subsystem: subsystem, category: group.rawLoggerCategory)
        osLogs[group.rawLoggerCategory] = osLog
        return osLog
    }
}

private extension LogType {
    var osLogType: OSLogType { OSLogType(rawValue) }
}

#endif // canImport(os)
