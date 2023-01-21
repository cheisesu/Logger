import Foundation

public protocol LoggerCategory {
    var string: String { get }
}

extension String: LoggerCategory {
    public var string: String { self }
}
