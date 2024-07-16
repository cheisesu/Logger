import Testing
import Foundation
@testable import Logger

struct CountingFileTransferPolicyTests {
    private let fileManager: FileManager = .default

    @Test("When there's no source file, and don't need to create it, nothing happens")
    func noSourceFileAndNoCreation() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)

        try policy.perform(for: sourceURL, recreateSource: false)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.isEmpty)
    }

    @Test("When there's no source file, and need to create it, creates the file")
    func noSourceFileWithCreation() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)

        try policy.perform(for: sourceURL, recreateSource: true)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.count == 1)
        try #require(urls[0] == sourceURL)
    }

    @Test
    func yesSourceWithCreating_MaxCount3_OneToTwoFiles() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)
        try Data().write(to: sourceURL, options: .atomic)
        let secondURL = sourceURL.appendingPathExtension("1")

        try #require(!fileManager.fileExists(atPath: secondURL.path))
        try policy.perform(for: sourceURL, recreateSource: true)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.count == 2)
        try #require(Set(urls) == Set([sourceURL, secondURL]))
    }

    @Test
    func yesSourceWithCreating_MaxCount3_TwoToThreeFiles() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)
        try Data().write(to: sourceURL, options: .atomic)
        let secondURL = sourceURL.appendingPathExtension("1")
        try Data().write(to: secondURL, options: .atomic)
        let thirdURL = sourceURL.appendingPathExtension("2")

        try #require(!fileManager.fileExists(atPath: thirdURL.path))
        try policy.perform(for: sourceURL, recreateSource: true)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.count == 3)
        try #require(Set(urls) == Set([sourceURL, secondURL, thirdURL]))
    }

    @Test
    func yesSourceWithCreating_MaxCount3_ThreeToThreeFiles() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceText = "t0"
        let secondText = "t1"
        let thirdText = "t2"
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)
        try sourceText.write(to: sourceURL, atomically: true, encoding: .utf8)
        let secondURL = sourceURL.appendingPathExtension("1")
        try secondText.write(to: secondURL, atomically: true, encoding: .utf8)
        let thirdURL = sourceURL.appendingPathExtension("2")
        try thirdText.write(to: thirdURL, atomically: true, encoding: .utf8)

        try policy.perform(for: sourceURL, recreateSource: true)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.count == 3)
        try #require(Set(urls) == Set([sourceURL, secondURL, thirdURL]))
        try #require(String(contentsOf: sourceURL, encoding: .utf8).isEmpty)
        try #require(String(contentsOf: secondURL, encoding: .utf8) == sourceText)
        try #require(String(contentsOf: thirdURL, encoding: .utf8) == secondText)
    }

    @Test
    func yesSourceWithCreating_MaxCount3_FourToThreeFiles() async throws {
        let policy: FileTransferPolicy = .counting(maxCount: 3)
        let fileName = "_test_\(#function).tt"
        let sourceDirURL = fileManager.temporaryDirectory.appendingPathComponent(#function, isDirectory: true).resolvingSymlinksInPath()
        try fileManager.createDirectory(at: sourceDirURL, withIntermediateDirectories: true)
        defer { try! fileManager.removeItem(at: sourceDirURL) }
        let sourceText = "t0"
        let secondText = "t1"
        let thirdText = "t2"
        let fourthText = "t3"
        let sourceURL = sourceDirURL.appendingPathComponent(fileName)
        try sourceText.write(to: sourceURL, atomically: true, encoding: .utf8)
        let secondURL = sourceURL.appendingPathExtension("1")
        try secondText.write(to: secondURL, atomically: true, encoding: .utf8)
        let thirdURL = sourceURL.appendingPathExtension("2")
        try thirdText.write(to: thirdURL, atomically: true, encoding: .utf8)
        let fourthURL = sourceURL.appendingPathExtension("3")
        try fourthText.write(to: fourthURL, atomically: true, encoding: .utf8)

        try policy.perform(for: sourceURL, recreateSource: true)

        let urls = try fileManager.contentsOfDirectory(at: sourceDirURL, includingPropertiesForKeys: nil)
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        try #require(urls.count == 3)
        try #require(Set(urls) == Set([sourceURL, secondURL, thirdURL]))
        try #require(String(contentsOf: sourceURL, encoding: .utf8).isEmpty)
        try #require(String(contentsOf: secondURL, encoding: .utf8) == sourceText)
        try #require(String(contentsOf: thirdURL, encoding: .utf8) == secondText)
        try #require(!fileManager.fileExists(atPath: fourthURL.path))
    }

    // MARK: - DEFAULT PERFORM CALL

    @Test
    func defaultCreateFileParamCallsOriginWithFalse() throws {
        final class _Mock: FileTransferPolicy {
            var performCalled = false
            var recreateSourceValue: Bool?

            func perform(for sourceURL: URL, recreateSource: Bool) throws {
                performCalled = true
                recreateSourceValue = recreateSource
            }
        }
        let mock = _Mock()
        let policy: FileTransferPolicy = mock
        try policy.perform(for: URL(fileURLWithPath: ""))

        try #require(mock.performCalled == true)
        try #require(mock.recreateSourceValue == false)
    }
}
