import Foundation
#if canImport(os)
import os
#endif

/// The various log levels that the unified logging system provides
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public struct LogType: RawRepresentable, Equatable, Sendable {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// Creates a new instance with the specified raw value
    /// - Parameter rawValue: The raw value to use for the new instance
    public init(_ rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension LogType {
#if canImport(os)
    /// The default log level
    public static let `default` = LogType(rawValue: OSLogType.default.rawValue)
    /// The informative log level
    public static let info = LogType(rawValue: OSLogType.info.rawValue)
    /// The debug log level
    public static let debug = LogType(rawValue: OSLogType.debug.rawValue)
    /// The error log level
    public static let error = LogType(rawValue: OSLogType.error.rawValue)
    /// The fault log level
    public static let fault = LogType(rawValue: OSLogType.fault.rawValue)
#else
    /// The default log level
    public static let `default` = LogType(rawValue: 0x00)
    /// The informative log level
    public static let info = LogType(rawValue: 0x01)
    /// The debug log level
    public static let debug = LogType(rawValue: 0x02)
    /// The error log level
    public static let error = LogType(rawValue: 0x10)
    /// The fault log level
    public static let fault = LogType(rawValue: 0x11)
#endif
}

