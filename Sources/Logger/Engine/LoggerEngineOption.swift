import Foundation

public struct LoggerEngineOption: OptionSet {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let printFile = LoggerEngineOption(rawValue: 1)
    public static let printLine = LoggerEngineOption(rawValue: 1 << 1)

    public static let `default`: LoggerEngineOption = [.printFile, .printLine]
}
