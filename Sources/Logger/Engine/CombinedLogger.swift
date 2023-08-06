import Foundation

/// Logger that combines other engines and acts as proxy
public class CombinedLogger: LoggerEngine {
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

    public func write(_ message: String, of category: LoggerCategory? = nil, as logType: LogType = .default,
                      _ file: String = #fileID, _ line: Int = #line) {
        engines.forEach { engine in
            engine.write(message, of: category, as: logType, file, line)
        }
    }

    public func flush() {
        engines.forEach { engine in
            engine.flush()
        }
    }
}
