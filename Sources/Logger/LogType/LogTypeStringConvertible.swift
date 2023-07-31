/// Provides a way to convert log type into a string
public protocol LogTypeStringConvertible {
    /// Converts passed log type to a string value
    ///
    /// - Parameter type: Type of a log message
    /// - Returns: Converted log message type to a string value or nil
    func string(for type: LogType) -> String?
}
