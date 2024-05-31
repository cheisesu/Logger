import Foundation

/// Describes what a logger have to do
public protocol LoggerEngine: Sendable {

    /// Writes a message to a logger source
    /// - Parameters:
    ///   - message: Log initial message
    ///   - category: Category of the message to indicate the message in a system
    ///   - logType: Type of the message
    ///   - file: File, where the method is called
    ///   - line: Line in the file
    func write(_ message: String, of category: LoggerCategory?, as logType: LogType, _ file: String, _ line: Int)
}

extension LoggerEngine {
    /// Writes a message to a logger source
    /// - Parameters:
    ///   - message: Log initial message
    ///   - category: Category of the message to indicate the message in a system
    ///   - logType: Type of the message
    ///   - file: File, where the method is called
    ///   - line: Line in the file
    public func write(_ message: String, of category: LoggerCategory? = nil, as logType: LogType,
                      _ file: String = #fileID, _ line: Int = #line) {
        write(message, of: category, as: logType, file, line)
    }

    /// Writes a message to a logger source with default log type
    /// - Parameters:
    ///   - message: Log initial message
    ///   - category: Category of the message to indicate the message in a system
    ///   - file: File, where the method is called
    ///   - line: Line in the file
    public func write(_ message: String, of category: LoggerCategory? = nil,
                      _ file: String = #fileID, _ line: Int = #line) {
        write(message, of: category, as: .default, file, line)
    }
}
