import Foundation

extension FileTransferPolicy where Self == CountingFileTransferPolicy {
    public static func counting(maxCount: Int) -> FileTransferPolicy {
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
        let sourceURL = sourceURL.resolvingSymlinksInPath()
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
            .map { $0.resolvingSymlinksInPath() }
            .filter { $0.path.starts(with: sourceURL.path) }
        let sortedURLs = urls.sorted { $0.path > $1.path }
        for url in sortedURLs {
            var number = UInt64(url.pathExtension) ?? 0
            let hasNumericExt = number > 0
            number += 1
            if number >= maxCount {
                try fileManager.removeItem(at: url)
            } else if hasNumericExt {
                let newURL = url.deletingPathExtension().appendingPathExtension("\(number)")
                try fileManager.moveItem(at: url, to: newURL)
            } else {
                let newURL = url.appendingPathExtension("\(number)")
                try fileManager.moveItem(at: url, to: newURL)
            }
        }
    }

    private func recreate(file sourceURL: URL) throws {
        try Data().write(to: sourceURL, options: .atomic)
    }
}
