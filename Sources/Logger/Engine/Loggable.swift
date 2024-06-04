import Foundation

public protocol Loggable {
    var logger: LoggerEngine { get }
    var category: LoggerCategory? { get }
}

extension Loggable {
    /// Wrapper to write default messages shortly from self.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil which will be replaced on the source category.
    public func log(_ items: Any..., category: LoggerCategory? = nil, file: String = #fileID, line: Int = #line) {
        logger.write(items, category: category ?? self.category, logType: .default, file: file, line: line)
    }

    /// Wrapper to write debug messages shortly from self.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil which will be replaced on the source category.
    public func logDebug(_ items: Any..., category: LoggerCategory? = nil, file: String = #fileID, line: Int = #line) {
        logger.write(items, category: category ?? self.category, logType: .debug, file: file, line: line)
    }

    /// Wrapper to write info messages shortly from self.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil which will be replaced on the source category.
    public func logInfo(_ items: Any..., category: LoggerCategory? = nil, file: String = #fileID, line: Int = #line) {
        logger.write(items, category: category ?? self.category, logType: .info, file: file, line: line)
    }

    /// Wrapper to write error messages shortly from self.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil which will be replaced on the source category.
    public func logError(_ items: Any..., category: LoggerCategory? = nil, file: String = #fileID, line: Int = #line) {
        logger.write(items, category: category ?? self.category, logType: .error, file: file, line: line)
    }

    /// Wrapper to write fault messages shortly from self.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil which will be replaced on the source category.
    public func logFault(_ items: Any..., category: LoggerCategory? = nil, file: String = #fileID, line: Int = #line) {
        logger.write(items, category: category ?? self.category, logType: .fault, file: file, line: line)
    }
}
