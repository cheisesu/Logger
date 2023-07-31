import Foundation

/// Options that may be used in a logger engine
public struct LoggerEngineOption: OptionSet {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// Indicates that printing file param value is needed
    public static let printFile = LoggerEngineOption(rawValue: 1)
    /// Indicates that printing line param value is needed
    public static let printLine = LoggerEngineOption(rawValue: 1 << 1)
    /// Indicates that printing category param value is needed
    public static let printCategory = LoggerEngineOption(rawValue: 1 << 2)
    
    /// Default combination of all options
    ///
    /// The list of used options:
    /// - <doc:printFile>
    /// - <doc:printLine>
    /// - <doc:printCategory>
    public static let `default`: LoggerEngineOption = [.printFile, .printLine, .printCategory]
    /// Combination of options used in system console logger
    ///
    /// The list of used options:
    /// - <doc:printFile>
    /// - <doc:printLine>
    public static let console: LoggerEngineOption = [.printFile, .printLine]
}
