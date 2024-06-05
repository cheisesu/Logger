import XCTest
@testable import Logger

final class DefaultLoggerMessageConstructor_tests: XCTestCase {
    private let sourceMessage1 = "source"
    private let sourceMessage2 = "message"
    private var fullSourceMessage: String {
        "\(sourceMessage1)\(separator)\(sourceMessage2)"
    }
    private let category: LoggerCategory = "category"
    private let logType: LogType = .debug
    private let file = "file"
    private let line = 11
    private let logTypeStringConverter: LogTypeStringConvertible = .default
    private var logTypeString: String {
        logTypeStringConverter.string(for: logType) ?? "default"
    }
    private let separator = " "
    private let terminator = "\n"

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func test_EmptyItems_ReturnsNil() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [], logTypeStringConverter: logTypeStringConverter)
        let message = constructor.makeMessage(category: category, logType: logType,
                                              separator: separator, terminator: terminator, file: file, line: line)
        XCTAssertNil(message)
    }

    func test_MultipleItems_JoinedWithCorrectSeparator() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\(terminator)")
    }

    func test_EmptyOptions_ResultsOnlyLogTypeAndSourceMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\(terminator)")
    }

    func test_PrintCategoryOption_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(fullSourceMessage)\(terminator)")
    }

    func test_PrintFileOption_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printFile], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\n\(file)\(terminator)")
    }

    func test_PrintLineOption_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printLine], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\n\(line)\(terminator)")
    }

    func test_PrintCategoryAndFileOptions_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printFile], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(fullSourceMessage)\n\(file)\(terminator)")
    }

    func test_PrintCategoryAndLineOptions_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printLine], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(fullSourceMessage)\n\(line)\(terminator)")
    }

    func test_PrintFileAndLineOptions_ResultsCorrectMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printFile, .printLine], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\n\(file):\(line)\(terminator)")
    }

    func test_PrintCategoryFileAndLineOptions_ResultsFullMessage() throws {
        let constructor = DefaultLoggerMessageConstructor(options: [.printCategory, .printLine, .printFile], logTypeStringConverter: logTypeStringConverter)
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(fullSourceMessage)\n\(file):\(line)\(terminator)")
    }

    // MARK: EXTENSIONS

    func test_DefaultLogger_ResultsFullMessage() throws {
        let constructor: LoggerMessageConstructor = .default
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "[\(category)] \(logTypeString) \(fullSourceMessage)\n\(file):\(line)\(terminator)")
    }

    func test_ConsoleLogger_ResultsMessageWithoutCategory() throws {
        let constructor: LoggerMessageConstructor = .console
        let _message = constructor.makeMessage(from: sourceMessage1, sourceMessage2,
                                               category: category, logType: logType,
                                               separator: separator, terminator: terminator, file: file, line: line)
        let message = try XCTUnwrap(_message)
        XCTAssertEqual(message, "\(logTypeString) \(fullSourceMessage)\n\(file):\(line)\(terminator)")
    }
}
