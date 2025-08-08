import XCTest
@testable import LoggerKit

final class DefaultLogTypeStringConverter_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    // MARK: - CIRCLE OPTION

    func test_ConvertCircle_NoCircleOption_ReturnsNil() {
        let converter = DefaultLogTypeStringConverter(options: [])

        XCTAssertNil(converter.circle(for: .debug))
        XCTAssertNil(converter.circle(for: .info))
        XCTAssertNil(converter.circle(for: .default))
        XCTAssertNil(converter.circle(for: .error))
        XCTAssertNil(converter.circle(for: .fault))
        XCTAssertNil(converter.circle(for: .init(.max)))
    }

    func test_ConvertCircle_WithCircleOption_ReturnsCorrectWalue() {
        let converter = DefaultLogTypeStringConverter(options: [.useCircle])

        XCTAssertEqual(converter.circle(for: .debug), "🔵")
        XCTAssertEqual(converter.circle(for: .info), "🟢")
        XCTAssertEqual(converter.circle(for: .default), "🟢")
        XCTAssertEqual(converter.circle(for: .error), "🟠")
        XCTAssertEqual(converter.circle(for: .fault), "🔴")
        XCTAssertEqual(converter.circle(for: .init(.max)), "🟤")
    }

    // MARK: - NAME OPTION

    func test_ConvertName_NoNameOption_ReturnsNil() {
        let converter = DefaultLogTypeStringConverter(options: [])

        XCTAssertNil(converter.name(for: .debug))
        XCTAssertNil(converter.name(for: .info))
        XCTAssertNil(converter.name(for: .default))
        XCTAssertNil(converter.name(for: .error))
        XCTAssertNil(converter.name(for: .fault))
        XCTAssertNil(converter.name(for: .init(.max)))
    }

    func test_ConvertName_NoNameOption_ReturnsCorrectWalue() {
        let converter = DefaultLogTypeStringConverter(options: [.useName])

        XCTAssertEqual(converter.name(for: .debug), "DEBUG")
        XCTAssertEqual(converter.name(for: .info), "INFO")
        XCTAssertEqual(converter.name(for: .default), "DEFAULT")
        XCTAssertEqual(converter.name(for: .error), "ERROR")
        XCTAssertEqual(converter.name(for: .fault), "FAULT")
        XCTAssertEqual(converter.name(for: .init(.max)), "UNKNOWN")
    }

    // MARK: - FINAL STRING

    func test_FinalString_NoCircleNoName_ReturnsNil() {
        let converter = DefaultLogTypeStringConverter(options: [])

        XCTAssertNil(converter.string(for: .debug))
        XCTAssertNil(converter.string(for: .info))
        XCTAssertNil(converter.string(for: .default))
        XCTAssertNil(converter.string(for: .error))
        XCTAssertNil(converter.string(for: .fault))
        XCTAssertNil(converter.string(for: .init(.max)))
    }

    func test_FinalString_NoCircleWithName_ReturnsCorrectValue() {
        let converter = DefaultLogTypeStringConverter(options: [.useName])

        XCTAssertEqual(converter.string(for: .debug), "DEBUG")
        XCTAssertEqual(converter.string(for: .info), "INFO")
        XCTAssertEqual(converter.string(for: .default), "DEFAULT")
        XCTAssertEqual(converter.string(for: .error), "ERROR")
        XCTAssertEqual(converter.string(for: .fault), "FAULT")
        XCTAssertEqual(converter.string(for: .init(.max)), "UNKNOWN")
    }

    func test_FinalString_WithCircleNoName_ReturnsCorrectValue() {
        let converter = DefaultLogTypeStringConverter(options: [.useCircle])

        XCTAssertEqual(converter.string(for: .debug), "🔵")
        XCTAssertEqual(converter.string(for: .info), "🟢")
        XCTAssertEqual(converter.string(for: .default), "🟢")
        XCTAssertEqual(converter.string(for: .error), "🟠")
        XCTAssertEqual(converter.string(for: .fault), "🔴")
        XCTAssertEqual(converter.string(for: .init(.max)), "🟤")
    }

    func test_FinalString_WithCircleWithName_ReturnsCorrectValue() {
        let converter = DefaultLogTypeStringConverter(options: [.useName, .useCircle])

        XCTAssertEqual(converter.string(for: .debug), "DEBUG 🔵")
        XCTAssertEqual(converter.string(for: .info), "INFO 🟢")
        XCTAssertEqual(converter.string(for: .default), "DEFAULT 🟢")
        XCTAssertEqual(converter.string(for: .error), "ERROR 🟠")
        XCTAssertEqual(converter.string(for: .fault), "FAULT 🔴")
        XCTAssertEqual(converter.string(for: .init(.max)), "UNKNOWN 🟤")
    }

    func test_DefaultInstantiatedConverter_ProvidesCorrectValues() {
        let converter: LogTypeStringConvertible = .default

        XCTAssertEqual(converter.string(for: .debug), "DEBUG 🔵")
        XCTAssertEqual(converter.string(for: .info), "INFO 🟢")
        XCTAssertEqual(converter.string(for: .default), "DEFAULT 🟢")
        XCTAssertEqual(converter.string(for: .error), "ERROR 🟠")
        XCTAssertEqual(converter.string(for: .fault), "FAULT 🔴")
        XCTAssertEqual(converter.string(for: .init(.max)), "UNKNOWN 🟤")
    }
}
