import Foundation
import os

public class ConsoleLogger: LoggerEngine {
    private let osLogsLock: NSLock
    private var osLogs: [String: OSLog]
    private let queue: OperationQueue
    private let options: LoggerEngineOption
    private let logTypeStringConverter: LogTypeStringConvertible
    private let defaultCategory: LoggerCategory
    private let subsystem: String

    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "logger.box.console",
                defaultCategory: LoggerCategory = "default",
                options: LoggerEngineOption = .default,
                logTypeStringConverter: LogTypeStringConvertible = .default)
    {
        self.subsystem = subsystem
        self.defaultCategory = defaultCategory
        osLogsLock = NSLock()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "logger.queue.box.console"
        osLogs = [
            defaultCategory.string: OSLog(subsystem: subsystem, category: defaultCategory.string)
        ]
        self.options = options
        self.logTypeStringConverter = logTypeStringConverter
    }

    public func write(group: LoggerCategory? = nil, _ message: String, logType: LogType, _ file: String = #filePath, _ line: Int = #line) {
        guard let osLog = osLog(for: group) else { return }
        let message = logMessage(from: message, logType: logType, file, line)
        queue.addOperation {
            os_log("%{public}@", log: osLog, type: logType, message)
        }
    }

    public func write(group: LoggerCategory? = nil, _ message: String, logType: LogType, _ file: String = #filePath, _ line: Int = #line) async {
        guard let osLog = osLog(for: group) else { return }
        let message = logMessage(from: message, logType: logType, file, line)
        await withUnsafeContinuation { continuation in
            queue.addOperation {
                os_log("%{public}@", log: osLog, type: logType, message)
                continuation.resume()
            }
        }
    }

    public func flush() {
        queue.waitUntilAllOperationsAreFinished()
    }

    public func flush() async {
        await withUnsafeContinuation { [queue] continuation in
            queue.waitUntilAllOperationsAreFinished()
            continuation.resume()
        }
    }

    public func logMessage(from message: String, logType: LogType, _ file: String, _ line: Int) -> String {
        var resultMessage = message

        if let typeString = logTypeStringConverter.string(for: logType) {
            resultMessage = "\(typeString) \(resultMessage)"
        }

        var meta: [String] = []
        if options.contains(.printFile) {
            meta.append(file)
        }
        if options.contains(.printLine) {
            meta.append("\(line)")
        }
        let metaString = meta.joined(separator: ":")
        let result = [resultMessage, metaString].joined(separator: "\n")
        return result
    }
}

// MARK: - PRIVATE METHODS

extension ConsoleLogger {
    private func osLog(for group: LoggerCategory?) -> OSLog? {
        osLogsLock.lock()
        defer { osLogsLock.unlock() }

        let group = group ?? defaultCategory
        if let log = osLogs[group.string] {
            return log
        }
        let osLog = OSLog(subsystem: subsystem, category: group.string)
        osLogs[group.string] = osLog
        return osLog
    }
}
