import Foundation
import os

/// The various log levels that the unified logging system provides
public struct LogType: RawRepresentable, Equatable {
    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// Creates a new instance with the specified raw value
    /// - Parameter rawValue: The raw value to use for the new instance
    public init(_ rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

extension LogType {
    private init(osLogType: OSLogType) {
        rawValue = osLogType.rawValue
    }

    /// The default log level
    public static let `default` = LogType(osLogType: .default)
    /// The informative log level
    public static let info = LogType(osLogType: .info)
    /// The debug log level
    public static let debug = LogType(osLogType: .debug)
    /// The error log level
    public static let error = LogType(osLogType: .error)
    /// The fault log level
    public static let fault = LogType(osLogType: .fault)
}
