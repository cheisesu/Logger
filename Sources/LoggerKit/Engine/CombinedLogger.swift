import Foundation

/// Logger that combines other engines and acts as proxy
public final class CombinedLogger: Sendable {
    private let engines: [LoggerEngine]

    /// Constructs with other engines
    /// - Parameter engines: Array of engine instances
    public init(_ engines: [LoggerEngine]) {
        self.engines = engines
    }

    /// Constructs with other engines
    /// - Parameter engines: Engine instances
    public init(_ engines: LoggerEngine...) {
        self.engines = engines
    }
}

// MARK: - LOGGER ENGINE CONFORMANCE

extension CombinedLogger: LoggerEngine {
    public func write(_ items: [Any], category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int)
    {
        engines.forEach { engine in
            engine.write(items, category: category, logType: logType, separator: separator, terminator: terminator, file: file, line: line)
        }
    }

    public func writeAsync(_ items: [any Sendable], category: (any LoggerCategory)?, logType: LogType,
                           separator: String, terminator: String, file: String, line: Int) async
    {
        await withTaskGroup { group in
            engines.forEach { engine in
                group.addTask {
                    await engine.writeAsync(items, category: category, logType: logType, separator: separator,
                                            terminator: terminator, file: file, line: line)
                }
            }

            await group.waitForAll()
        }
    }
}
