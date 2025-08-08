import XCTest
@testable import LoggerKit

final class LoggerEngineOption_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_Init_SetsPassedRawValue() {
        let option = LoggerEngineOption(rawValue: 10)
        XCTAssertEqual(option.rawValue, 10)
    }
}
