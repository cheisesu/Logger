import XCTest
@testable import Logger

final class DefaultLogTypeStringConverter_Option_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_Init_SetsPassedRawValue() {
        let option = DefaultLogTypeStringConverter.Option(rawValue: 10)
        XCTAssertEqual(option.rawValue, 10)
    }
}
