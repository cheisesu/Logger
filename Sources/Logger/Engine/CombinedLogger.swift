import Foundation

/// Logger that combines other engines and acts as proxy
public final class CombinedLogger: LoggerEngine, Sendable {
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

    public func write(_ items: Any..., category: (any LoggerCategory)?, logType: LogType,
                      separator: String, terminator: String, file: String, line: Int) {
        engines.forEach { engine in
            engine.write(items, category: category, logType: logType, separator: separator, terminator: terminator, file: file, line: line)
        }
    }
}
