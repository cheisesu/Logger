/// Provides a way to convert log type into a string
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol LogTypeStringConvertible: Sendable {
    /// Converts passed log type to a string value
    ///
    /// - Parameter type: Type of a log message
    /// - Returns: Converted log message type to a string value or nil
    func string(for type: LogType) -> String?
}
