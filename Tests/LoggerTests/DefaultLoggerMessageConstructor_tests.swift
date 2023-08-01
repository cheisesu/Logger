import XCTest
@testable import Logger

final class DefaultLoggerMessageConstructor_tests: XCTestCase {
    private let sourceMessage = "source message"
    private let category: LoggerCategory = "category"
    private let logType: LogType = .debug
    private let file = "file"
    private let line = 11
    private let logTypeStringConverter: LogTypeStringConvertible = .default
    private var logTypeString: String {
        logTypeStringConverter.string(for: logType) ?? ""
    }

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func test_MakeMessage_EmptyOptions_ResultsOnlyLogTypeAndSourceMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "\(logTypeString) \(sourceMessage)")
    }

    func test_MakeMessage_PrintCategoryOption_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(sourceMessage)")
    }

    func test_MakeMessage_PrintFileOption_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printFile], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "\(logTypeString) \(sourceMessage)\n\(file)")
    }

    func test_MakeMessage_PrintLineOption_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printLine], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "\(logTypeString) \(sourceMessage)\n\(line)")
    }

    func test_MakeMessage_PrintCategoryAndFileOptions_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printFile], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(sourceMessage)\n\(file)")
    }

    func test_MakeMessage_PrintCategoryAndLineOptions_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printLine], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(sourceMessage)\n\(line)")
    }

    func test_MakeMessage_PrintFileAndLineOptions_ResultsCorrectMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printFile, .printLine], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "\(logTypeString) \(sourceMessage)\n\(file):\(line)")
    }

    func test_MakeMessage_PrintCategoryFileAndLineOptions_ResultsFullMessage() {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printLine, .printFile], logTypeStringConverter: logTypeStringConverter)

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(sourceMessage)\n\(file):\(line)")
    }

    // MARK: - EXTENSIONS

    func test_DefaultLogger_MakeMessage_ResultsFullMessage() {
        let constructor: LoggerMessageConstructor = .default

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(sourceMessage)\n\(file):\(line)")
    }

    func test_ConsoleLogger_MakeMessage_ResultsMessageWithoutCategory() {
        let constructor: LoggerMessageConstructor = .console

        let message = constructor.makeMessage(from: sourceMessage, of: category, as: logType, file, line)

        XCTAssertEqual(message, "\(logTypeString) \(sourceMessage)\n\(file):\(line)")
    }
}
