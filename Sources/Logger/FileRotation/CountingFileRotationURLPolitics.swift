import Foundation

public protocol FileLimitsPolitics: Sendable {
    var maxSize: Measurement<UnitInformationStorage> { get }
}

public final class CountingFileRotationURLPolitics: FileURLRotationPolitics, @unchecked Sendable {
    private let fileManagerLock: NSLock
    private let fileManager: FileManager
    private let maxNumber: Int

    public init(fileManager: FileManager = .default, maxNumber: Int) {
        fileManagerLock = NSLock()
        self.fileManager = fileManager
        self.maxNumber = maxNumber
    }

    public func nextFileURL(for source: URL) -> URL {
        guard maxNumber > 0 else { return source }
        fileManagerLock.lock()
        defer { fileManagerLock.unlock() }
        guard let nextNumber = nextNumber(for: source) else { return source }
        let newURL = source.appendingPathExtension("\(nextNumber)")
        print("next url", newURL)
        return newURL
    }

    private func nextNumber(for source: URL) -> Int? {
        let exists = fileManager.fileExists(atPath: source.path)
        guard exists else { return nil }
        let name = source.lastPathComponent
        let directory = source.deletingLastPathComponent()
        let urls = (try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? []
        let filterred = urls.filter { $0.deletingPathExtension().lastPathComponent == name }
        let ints = filterred.compactMap { Int($0.pathExtension) }
        let value = (ints.max() ?? 0) + 1
        return min(value, maxNumber)
    }
}

extension FileURLRotationPolitics where Self == CountingFileRotationURLPolitics {
    public static func counting(maxNumber: Int = 1) -> FileURLRotationPolitics {
        CountingFileRotationURLPolitics(maxNumber: maxNumber)
    }
}
