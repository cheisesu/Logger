import Foundation

/// Provides possibility to use custom type for logger category
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol LoggerCategory: Sendable {
    /// String representation for a category instance
    var rawLoggerCategory: String { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension String: LoggerCategory {
    public var rawLoggerCategory: String { self }
}
