import Foundation

/// Provides possibility to use custom type for logger category
public protocol LoggerCategory {
    /// String representation for a category instance
    var rawLoggerCategory: String { get }
}

extension String: LoggerCategory {
    public var rawLoggerCategory: String { self }
}
