import XCTest
@testable import Logger

final class String_LoggerCategory_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_StringLoggerCategory_ProvidesSameValueAsSelf() {
        let str = "test_category"
        let category: LoggerCategory = str
        XCTAssertEqual(str, category.rawLoggerCategory)
    }
}
