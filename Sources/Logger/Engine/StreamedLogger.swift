import Foundation

public class StreamedLogger: LoggerEngine {
    private let defaultCategory: LoggerCategory
    private let messageConstructor: LoggerMessageConstructor
    private var stream: LoggerStream

    public init(defaultCategory: LoggerCategory, messageConstructor: LoggerMessageConstructor, stream: LoggerStream) {
        self.defaultCategory = defaultCategory
        self.messageConstructor = messageConstructor
        self.stream = stream
    }

    public func write(_ message: String, of category: LoggerCategory? = nil, as logType: LogType = .default,
                      _ file: String = #fileID, _ line: Int = #line) {
        let message = messageConstructor.makeMessage(from: message, of: category ?? defaultCategory, as: logType, file, line)
        stream.write(message + "\n")
    }

    public func flush() {
        stream.flush()
    }
}
