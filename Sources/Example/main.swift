import Foundation
import Logger

extension LogType {
    static func random() -> LogType {
        [LogType.debug, .default, .error, .info, .fault].randomElement() ?? .default
    }
}

let constructor = DefaultLoggerMessageConstructor(options: .printCategory)
let consoleLogger: LoggerEngine = ConsoleLogger(defaultCategory: "EXAMPLE", messageConstructor: constructor)
let fileURL = URL(fileURLWithPath: "\(NSHomeDirectory())/Desktop/example.log")
let fileStream = try FileLoggerStream(fileURL, fileLimits: 2024, fileTransferPolicy: .counting(maxCount: 2))
let fileLogger: LoggerEngine = StreamedLogger(defaultCategory: "FILE_EXAMPLE", messageConstructor: constructor, stream: fileStream)
let logger: LoggerEngine = CombinedLogger(consoleLogger, fileLogger)

let group = DispatchGroup()
let count = 100
for _ in 0..<count {
    group.enter()
}
DispatchQueue.concurrentPerform(iterations: count) { index in
    let wait = UInt32.random(in: 1..<3)
    sleep(wait)
    logger.write("Step", index, ": logging after sleeping during", wait, "seconds", "on thread", Thread.current, logType: .random())
    group.leave()
}

group.wait()
