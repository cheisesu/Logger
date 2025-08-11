import Foundation

/// A type that can be the target of text-streaming operations
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol LoggerStream: TextOutputStream, Sendable {
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol AsyncLoggerStream: LoggerStream {
    mutating func writeAsync(_ string: String) async
}
