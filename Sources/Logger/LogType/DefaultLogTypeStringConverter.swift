import Foundation

extension LogTypeStringConvertible where Self == DefaultLogTypeStringConverter {
    public static var `default`: LogTypeStringConvertible { DefaultLogTypeStringConverter() }
}

/// Default implementation of converting provided types of log messages to a string
open class DefaultLogTypeStringConverter: LogTypeStringConvertible {
    /// Indicates options for converting
    public struct Option: OptionSet {
        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Indicates that circles will be used for default log types as a part of the result value
        ///
        /// For example: <doc:LogType/debug> will be converted to 🔵
        public static let useCircle = Option(rawValue: 1)
        /// Indicates that string representation will be used for default log types as a part of the result value
        ///
        /// For example: <doc:LogType/debug> will be converted to `DEBUG`
        public static let useName = Option(rawValue: 1 << 1)
    }

    private let options: Option

    /// Initializes converter with options
    /// - Parameter options: Options of converting. See <doc:DefaultLogTypeStringConverter/Option>
    public init(options: Option = [.useName, .useCircle]) {
        self.options = options
    }

    /// Converts passed log type to a string value based on options
    ///
    /// It converts passed type using provided options such order: `<name> <circle>`
    /// - Parameter type: Type of log message. See <doc:LogType>
    /// - Returns: Converted string, based on options or nil.
    open func string(for type: LogType) -> String? {
        let components = [name(for: type), circle(for: type)].compactMap { $0 }
        guard !components.isEmpty else { return nil }
        let result = components.joined(separator: " ")
        return result
    }

    /// Provides circle for passed log message type
    /// - Parameter type: Type of log message. See <doc:LogType>
    /// - Returns: Converted circle string or nil if <doc:Option/useCircle> not set
    open func circle(for type: LogType) -> String? {
        guard options.contains(.useCircle) else { return nil }

        switch type {
        case .debug: return "🔵"
        case .info: return "🟢"
        case .default: return "🟢"
        case .error: return "🟠"
        case .fault: return "🔴"
        default: return "🟤"
        }
    }

    /// Provides string representation for passed log message type
    /// - Parameter type: Type of log message. See <doc:LogType>
    /// - Returns: Converted string or nil if <doc:Option/useName> not set
    open func name(for type: LogType) -> String? {
        guard options.contains(.useName) else { return nil }

        switch type {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .default: return "DEFAULT"
        case .error: return "ERROR"
        case .fault: return "FAULT"
        default: return "UNKNOWN"
        }
    }
}
