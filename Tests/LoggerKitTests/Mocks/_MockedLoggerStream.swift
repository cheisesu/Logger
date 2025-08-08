import Foundation
@testable import LoggerKit

final class _MockedLoggerStream: LoggerStream, @unchecked Sendable {
    var writeCalled: Bool = false
    var writeMessage: String?

    func write(_ string: String) {
        writeCalled = true
        writeMessage = string
    }
}
