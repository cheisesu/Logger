import Foundation

/// Provides methods to construct final log messages based on arguments
public protocol LoggerMessageConstructor: Sendable {
    /// Constructs final message from passed parameters.
    ///
    /// - Parameters:
    ///   - sourceMessage: Initial message
    ///   - category: Category of message in the system
    ///   - logType: Type of message
    ///   - file: File where engine's write method was called
    ///   - line: Line in the file
    /// - Returns: Constructed string
    @available(*, deprecated, renamed: "makeMessage(from:category:logType:separator:terminator:file:line:)")
    func makeMessage(from sourceMessage: String, of category: LoggerCategory,
                     as logType: LogType, _ file: String, _ line: Int) -> String

    /// Constructs final message from passed parameters.
    /// - Parameters:
    ///   - items: Zero or more items from which to make message.
    ///   - category: Category of the message to indicate it in a system.
    ///   - logType: Type of the message.
    ///   - separator: A string to print between each item.
    ///   - terminator: The string to print after all items have been printed.
    ///   - file: File, where the method is called.
    ///   - line: Line in the file.
    /// - Returns: Constructed string or nil if a string cannot be created.
    func makeMessage(from items: Any..., category: LoggerCategory, logType: LogType, separator: String, terminator: String,
                     file: String, line: Int) -> String?
}
