import Foundation

/// A type that can be the target of text-streaming operations
public protocol LoggerStream: TextOutputStream {
    func flush()
}
