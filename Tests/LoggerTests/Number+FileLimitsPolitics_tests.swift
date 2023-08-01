import XCTest
@testable import Logger

final class Number_FileLimitsPolitics_tests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    // MARK: - UNSIGNED INTS

    func test_UInt64_ReturnsCorrectValue() {
        let value = UInt64(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_UInt32_ReturnsCorrectValue() {
        let value = UInt32(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_UInt16_ReturnsCorrectValue() {
        let value = UInt16(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_UInt8_ReturnsCorrectValue() {
        let value = UInt8(123)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_UInt_ReturnsCorrectValue() {
        let value = UInt(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    // MARK: - SIGNED INTS

    func test_Int64_ReturnsCorrectValue() {
        let value = Int64(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Int32_ReturnsCorrectValue() {
        let value = Int32(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Int16_ReturnsCorrectValue() {
        let value = Int16(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Int8_ReturnsCorrectValue() {
        let value = Int8(123)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Int_ReturnsCorrectValue() {
        let value = Int(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    // MARK: - FLOATS

    func test_Double_ReturnsCorrectValue() {
        let value = Double(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Float_ReturnsCorrectValue() {
        let value = Float(1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }

    func test_Float16_ReturnsCorrectValue() {
        if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            let value = Float16(1234)
            let politics: FileLimitsPolitics = value
            XCTAssertEqual(politics.maxSize.value, Double(value))
        } else {
        }
    }

    func test_Float_Negative_ReturnsCorrectValue() {
        let value = Float(-1234)
        let politics: FileLimitsPolitics = value
        XCTAssertEqual(politics.maxSize.value, Double(value))
    }
}
