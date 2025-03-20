import Foundation

extension CombinedLogger {
    /// Actor implementation of ``CombinedLogger``.
    /// 
    /// Logger that combines other engines and acts as proxy.
    public actor Async: AsyncLoggerEngine {
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

        public nonisolated func write(_ items: Any..., category: (any LoggerCategory)?, logType: LogType,
                                      separator: String, terminator: String, file: String, line: Int) async
        {
            engines.forEach { engine in
                engine.write(items, category: category, logType: logType, separator: separator,
                             terminator: terminator, file: file, line: line)
            }
        }
    }
}
