import Foundation
@testable import Logger

final class _MockedLoggerStream: LoggerStream {
    var flushCalled: Bool = false
    var writeCalled: Bool = false
    var writeMessage: String?

    func write(_ string: String) {
        writeCalled = true
        writeMessage = string
    }

    func flush() {
        flushCalled = true
    }
}
