import Foundation

/// A type that can be the target of text-streaming operations
public protocol LoggerStream: TextOutputStream, Sendable {
}

public protocol AsyncLoggerStream: LoggerStream {
    mutating func writeAsync(_ string: String) async
}
