import Foundation

/// Default constructor of final messages for logger engines
public struct DefaultLoggerMessageConstructor: LoggerMessageConstructor, @unchecked Sendable {
    private let options: LoggerEngineOption
    private let logTypeStringConverter: LogTypeStringConvertible

    /// Creates a  new instances with options and log type converter
    /// - Parameters:
    ///   - options: Options to determine which params will be used for final message
    ///   - logTypeStringConverter: Converter of log type
    public init(options: LoggerEngineOption = .default, logTypeStringConverter: LogTypeStringConvertible = .default) {
        self.options = options
        self.logTypeStringConverter = logTypeStringConverter
    }

    public func makeMessage(from items: Any..., category: any LoggerCategory, logType: LogType,
                            separator: String, terminator: String, file: String, line: Int) -> String? {
        guard !items.isEmpty else { return nil }
        var resultMessage = items.map { String(describing: $0) }.joined(separator: separator)

        if let typeString = logTypeStringConverter.string(for: logType) {
            resultMessage = "\(typeString) \(resultMessage)"
        }

        if options.contains(.printCategory) {
            resultMessage = "[\(category.rawLoggerCategory)] \(resultMessage)"
        }

        var meta: [String] = []
        if options.contains(.printFile) {
            meta.append(file)
        }
        if options.contains(.printLine) {
            meta.append("\(line)")
        }
        var metaString: String? = meta.joined(separator: ":")
        if metaString?.count == 0 {
            metaString = nil
        }
        let result = [resultMessage, metaString].compactMap { $0 }.joined(separator: "\n") + terminator
        return result
    }
}

extension LoggerMessageConstructor where Self == DefaultLoggerMessageConstructor {
    /// Default message constructor that uses all default logger options
    public static var `default`: LoggerMessageConstructor {
        DefaultLoggerMessageConstructor()
    }

    /// Logger message constructor that is used with console engine with console engine options
    public static var console: LoggerMessageConstructor {
        DefaultLoggerMessageConstructor(options: .console)
    }
}

// MARK: - DEPRECATIONS

extension DefaultLoggerMessageConstructor {
    /// Constructs final message from passed parameters.
    ///
    /// This method uses provided options to construct a message in such form:
    ///
    /// ```
    /// [<category>] <log_type> <source_message>
    /// <file>:<line>
    /// ```
    ///
    /// - Parameters:
    ///   - sourceMessage: Initial message
    ///   - category: Category of message in the system
    ///   - logType: Type of message
    ///   - file: File where engine's write method was called
    ///   - line: Line in the file
    /// - Returns: Constructed string based on options
    @available(*, deprecated, renamed: "makeMessage(from:category:logType:separator:terminator:file:line:)")
    public func makeMessage(from sourceMessage: String, of category: LoggerCategory,
                            as logType: LogType, _ file: String, _ line: Int) -> String {
        var resultMessage = sourceMessage

        if let typeString = logTypeStringConverter.string(for: logType) {
            resultMessage = "\(typeString) \(resultMessage)"
        }

        if options.contains(.printCategory) {
            resultMessage = "[\(category.rawLoggerCategory)] \(resultMessage)"
        }

        var meta: [String] = []
        if options.contains(.printFile) {
            meta.append(file)
        }
        if options.contains(.printLine) {
            meta.append("\(line)")
        }
        var metaString: String? = meta.joined(separator: ":")
        if metaString?.count == 0 {
            metaString = nil
        }
        let result = [resultMessage, metaString].compactMap { $0 }.joined(separator: "\n")
        return result
    }
}
