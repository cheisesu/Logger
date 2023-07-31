import Foundation

/// Provides methods to construct final log messages based on arguments
public protocol LoggerMessageConstructor {
    /// Constructs final message from passed parameters.
    ///
    /// - Parameters:
    ///   - sourceMessage: Initial message
    ///   - category: Category of message in the system
    ///   - logType: Type of message
    ///   - file: File where engine's write method was called
    ///   - line: Line in the file
    /// - Returns: Constructed string
    func makeMessage(from sourceMessage: String, of category: LoggerCategory,
                     as logType: LogType, _ file: String, _ line: Int) -> String
}
