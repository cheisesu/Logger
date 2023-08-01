import Foundation

public protocol FileLimitsPolitics {
    var maxSize: Measurement<UnitInformationStorage> { get }
}

public final class CountingFileRotationURLPolitics: FileURLRotationPolitics {
    private let fileManager: FileManager
    private let maxNumber: Int

    public init(fileManager: FileManager = .default, maxNumber: Int) {
        self.fileManager = fileManager
        self.maxNumber = maxNumber
    }

    public func nextFileURL(for source: URL) -> URL {
        guard maxNumber > 0 else { return source }
        guard let nextNumber = nextNumber(for: source) else { return source }
        let newURL = source.appendingPathExtension("\(nextNumber)")
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
