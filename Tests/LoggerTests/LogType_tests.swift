import XCTest
@testable import Logger
import os

final class LogType_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_InnerLogTypeValues_EqualToSystemOSLogType() {
        XCTAssertEqual(LogType.default.rawValue, OSLogType.default.rawValue)
        XCTAssertEqual(LogType.debug.rawValue, OSLogType.debug.rawValue)
        XCTAssertEqual(LogType.info.rawValue, OSLogType.info.rawValue)
        XCTAssertEqual(LogType.error.rawValue, OSLogType.error.rawValue)
        XCTAssertEqual(LogType.fault.rawValue, OSLogType.fault.rawValue)
    }

    func test_InitWithRawValue_SetsTheSameValue() {
        XCTAssertEqual(LogType(10).rawValue, 10)
        XCTAssertEqual(LogType(rawValue: 10).rawValue, 10)
    }
}
