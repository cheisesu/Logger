import Foundation

/// Logger that combines other engines and acts as proxy
public final class CombinedLogger: LoggerEngine, @unchecked Sendable {
    private let enginesLock: NSLock
    private let engines: [LoggerEngine]

    /// Constructs with other engines
    /// - Parameter engines: Array of engine instances
    public init(_ engines: [LoggerEngine]) {
        enginesLock = NSLock()
        self.engines = engines
    }

    /// Constructs with other engines
    /// - Parameter engines: Engine instances
    public init(_ engines: LoggerEngine...) {
        enginesLock = NSLock()
        self.engines = engines
    }

    public func write(_ message: String, of category: LoggerCategory?, as logType: LogType,
                      _ file: String, _ line: Int) {
        engines.forEach { engine in
            engine.write(message, of: category, as: logType, file, line)
        }
    }
}
