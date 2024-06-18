import Foundation

extension FileTransferPolicy {
    public static func counting(maxCount: Int) -> any FileTransferPolicy {
        CountingFileTransferPolicy(maxCount: maxCount)
    }
}

public class CountingFileTransferPolicy: @unchecked Sendable, FileTransferPolicy {
    public enum PerformError: Error {
        case unacceptedURL
    }

    private let fileManager: FileManager
    private let maxCount: Int

    public init(fileManager: FileManager = .default, maxCount: Int) {
        self.fileManager = fileManager
        self.maxCount = max(maxCount, 1)
    }

    public func perform(for sourceURL: URL, recreateSource: Bool) throws {
        try checkURLCorrectness(sourceURL)
        try moveNextFiles(for: sourceURL)
        if recreateSource {
            try recreate(file: sourceURL)
        }
    }

    private func checkURLCorrectness(_ sourceURL: URL) throws(PerformError) {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: sourceURL.path, isDirectory: &isDirectory) else { return }
        guard !isDirectory.boolValue else { throw PerformError.unacceptedURL }
    }

    private func moveNextFiles(for sourceURL: URL) throws {
        let sourceDir = sourceURL.deletingLastPathComponent()
        let urls = try fileManager.contentsOfDirectory(at: sourceDir, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            .filter { $0.path.starts(with: sourceURL.pathExtension) }
        let mapping: [URL: URL] = urls.reduce([:]) { partialResult, url in
            var partialResult = partialResult
            if var number = UInt64(url.pathExtension) {
                number += 1
                partialResult[url] = url.appendingPathExtension("\(number)")
            } else {
                partialResult[url] = url.appendingPathExtension("1")
            }
            return partialResult
        }
        let sortedKeys = mapping.keys.sorted { $0.path > $1.path }
        let keysToDelete = sortedKeys.dropLast(maxCount)
        let keysToMove = sortedKeys.suffix(maxCount)
        for key in keysToDelete {
            try fileManager.removeItem(at: key)
        }
        for key in keysToMove {
            guard let value = mapping[key] else { continue }
            try fileManager.moveItem(at: key, to: value)
        }
    }

    private func recreate(file sourceURL: URL) throws {
        try Data().write(to: sourceURL, options: .atomic)
    }
}
