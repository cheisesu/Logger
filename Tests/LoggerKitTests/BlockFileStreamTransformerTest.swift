import Testing
import Foundation
@testable import LoggerKit

struct BlockFileStreamTransformerTests {
    @Test
    func transformDataBlockCalled() async throws {
        let block = BlockFileStreamTransformer { data in
            return Data(data.reversed())
        }
        let data = Data("Hello, World!".utf8)
        try #require(block.transform(data) == Data("!dlroW ,olleH".utf8))
    }
}
