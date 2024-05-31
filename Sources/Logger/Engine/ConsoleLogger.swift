import Foundation
import os

/// Logger engine of system console.
///
/// This engine writes messages to the system log, that you can see in Console.app.
public final class ConsoleLogger: LoggerEngine, @unchecked Sendable {
    private let osLogsLock: NSLock
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
        self.subsystem = subsystem
        self.defaultCategory = defaultCategory
        osLogsLock = NSLock()
        osLogs = [
            defaultCategory.rawLoggerCategory: OSLog(subsystem: subsystem, category: defaultCategory.rawLoggerCategory)
        ]
        self.messageConstructor = messageConstructor
    }

    public func write(_ message: String, of category: LoggerCategory? = nil, as logType: LogType = .default,
                      _ file: String = #fileID, _ line: Int = #line) {
        osLogsLock.lock()
        defer { osLogsLock.unlock() }
        guard let osLog = osLog(for: category) else { return }
        let message = messageConstructor.makeMessage(from: message, of: category ?? defaultCategory, as: logType, file, line)
        os_log("%{public}@", log: osLog, type: logType.osLogType, message)
    }
}

// MARK: - PRIVATE METHODS

extension ConsoleLogger {
    private func osLog(for group: LoggerCategory?) -> OSLog? {
        osLogsLock.lock()
        defer { osLogsLock.unlock() }

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
