import Foundation

/// Describes what a logger have to do
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol LoggerEngine: Sendable {
    /// Writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Array of items to write..
    ///   - category: Category of the message to indicate it in a system.
    ///   - logType: Type of the message.
    ///   - separator: A string to print between each item.
    ///   - terminator: The string to print after all items have been printed.
    ///   - file: File, where the method is called.
    ///   - line: Line in the file.
    @available(*, noasync, message: "Use async version of `LoggerEngine` instead.")
    func write(_ items: [Any], category: LoggerCategory?, logType: LogType, separator: String, terminator: String, file: String, line: Int)
    
    /// Writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Array of items to write..
    ///   - category: Category of the message to indicate it in a system.
    ///   - logType: Type of the message.
    ///   - separator: A string to print between each item.
    ///   - terminator: The string to print after all items have been printed.
    ///   - file: File, where the method is called.
    ///   - line: Line in the file.
    func writeAsync(_ items: [any Sendable], category: LoggerCategory?, logType: LogType, separator: String, terminator: String,
                    file: String, line: Int) async
}

// MARK: - SYNC OVERLOADS

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension LoggerEngine {
    /// Writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil.
    ///   - logType: Type of the message. The default value is <doc:LogType/default>.
    ///   - separator: A string to print between each item. The default is a single space (`" "`).
    ///   - terminator: The string to print after all items have been printed. The default is a newline (`"\n"`).
    ///   - file: File, where the method is called. The default value is `#fileID`.
    ///   - line: Line in the file. The default value is a number of line of the call (`#line`).
    @available(*, noasync, message: "Use async version of `LoggerEngine` instead.")
    public func write(_ items: Any..., category: LoggerCategory? = nil, logType: LogType = .default,
                      separator: String = " ", terminator: String = "\n",
                      file: String = #fileID, line: Int = #line)
    {
        write(items, category: category, logType: logType, separator: separator, terminator: terminator, file: file, line: line)
    }

    /// Writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Array of items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil.
    ///   - logType: Type of the message. The default value is <doc:LogType/default>.
    ///   - separator: A string to print between each item. The default is a single space (`" "`).
    ///   - terminator: The string to print after all items have been printed. The default is a newline (`"\n"`).
    ///   - file: File, where the method is called. The default value is `#fileID`.
    ///   - line: Line in the file. The default value is a number of line of the call (`#line`).
    @available(*, noasync, message: "Use async version of `LoggerEngine` instead.")
    public func write(_ items: [Any], category: LoggerCategory? = nil, logType: LogType = .default,
                      separator: String = " ", terminator: String = "\n",
                      file: String = #fileID, line: Int = #line)
    {
        write(items, category: category, logType: logType, separator: separator, terminator: terminator, file: file, line: line)
    }
}

// MARK: - ASYNC OVERLOADS

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension LoggerEngine {
    /// Asynchronously writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Zero or more items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil.
    ///   - logType: Type of the message. The default value is <doc:LogType/default>.
    ///   - separator: A string to print between each item. The default is a single space (`" "`).
    ///   - terminator: The string to print after all items have been printed. The default is a newline (`"\n"`).
    ///   - file: File, where the method is called. The default value is `#fileID`.
    ///   - line: Line in the file. The default value is a number of line of the call (`#line`).
    public func writeAsync(_ items: any Sendable..., category: LoggerCategory? = nil, logType: LogType = .default,
                           separator: String = " ", terminator: String = "\n",
                           file: String = #fileID, line: Int = #line) async
    {
        await writeAsync(items, category: category, logType: logType, separator: separator,
                         terminator: terminator, file: file, line: line)
    }
    
    /// Asynchronously writes the textual representations of the given items into the source engine.
    /// - Parameters:
    ///   - items: Array of items to write.
    ///   - category: Category of the message to indicate it in a system. The default value is nil.
    ///   - logType: Type of the message. The default value is <doc:LogType/default>.
    ///   - separator: A string to print between each item. The default is a single space (`" "`).
    ///   - terminator: The string to print after all items have been printed. The default is a newline (`"\n"`).
    ///   - file: File, where the method is called. The default value is `#fileID`.
    ///   - line: Line in the file. The default value is a number of line of the call (`#line`).
    public func writeAsync(_ items: [any Sendable], category: LoggerCategory? = nil, logType: LogType = .default,
                           separator: String = " ", terminator: String = "\n",
                           file: String = #fileID, line: Int = #line) async
    {
        await writeAsync(items, category: category, logType: logType, separator: separator,
                         terminator: terminator, file: file, line: line)
    }
}
