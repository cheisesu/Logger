import Foundation

extension LogTypeStringConvertible where Self == DefaultLogTypeStringConverter {
    public static var `default`: LogTypeStringConvertible { DefaultLogTypeStringConverter() }
}

open class DefaultLogTypeStringConverter: LogTypeStringConvertible {
    public struct Option: OptionSet {
        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let useCircle = Option(rawValue: 1)
        public static let useName = Option(rawValue: 1 << 1)
    }

    private let options: Option

    public init(options: Option = [.useName, .useCircle]) {
        self.options = options
    }

    open func string(for type: LogType) -> String? {
        let components = [name(for: type), circle(for: type)].compactMap { $0 }
        guard !components.isEmpty else { return nil }
        let result = components.joined(separator: " ")
        return result
    }

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
