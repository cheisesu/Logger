import Foundation

//#error("Loogs like it doesnt work properly with replacing files")

public final class FileLoggerStream: LoggerStream, @unchecked Sendable {
    private let sourceURL: URL
    private let fileHandleLock: NSLock
    private var fileHandle: FileHandle
    private let fileManager: FileManager
    private let fileLimits: FileLimitsPolitics
    private let rotationURLPolitics: FileURLRotationPolitics?
    private let currentSizeLock: NSLock
    private var currentSize: Measurement<UnitInformationStorage>

    public init(_ sourceURL: URL, fileManager: FileManager = .default,
                fileLimits: FileLimitsPolitics = 0, rotationURLPolitics: FileURLRotationPolitics? = nil) throws {
        self.sourceURL = sourceURL
        self.fileManager = fileManager
        self.fileLimits = fileLimits
        self.rotationURLPolitics = rotationURLPolitics
        fileHandleLock = NSLock()
        currentSizeLock = NSLock()

        if !fileManager.fileExists(atPath: sourceURL.path) {
            try Data().write(to: sourceURL)
        }
        fileHandle = try FileHandle(forUpdating: sourceURL)
        if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, *) {
            let data = try fileHandle.readToEnd() ?? Data()
            currentSize = Measurement(value: Double(data.count), unit: .bytes)
        } else {
            let data = fileHandle.readDataToEndOfFile()
            currentSize = Measurement(value: Double(data.count), unit: .bytes)
        }
        changeFile()
    }

    deinit {
        fileHandleLock.lock()
        defer { fileHandleLock.unlock() }
        do {
            try fileHandle.close()
        } catch {
        }
    }

    public func write(_ string: String) {
        fileHandleLock.lock()
        defer { fileHandleLock.unlock() }
        do {
            let data = Data(string.utf8)
            let size = Measurement(value: Double(data.count), unit: UnitInformationStorage.bytes)
            if #available(tvOS 13.4, macOS 10.15.4, iOS 13.4, *) {
                try fileHandle.write(contentsOf: data)
            } else {
                fileHandle.write(data)
            }
            currentSizeLock.lock()
            defer { currentSizeLock.unlock() }
            currentSize = currentSize + size
            if currentSize >= fileLimits.maxSize {
                changeFile()
            }
        } catch {
        }
    }

    /// - warning: this method should be used under `fileHandle` lock and `currentSize `lock.
    private func changeFile() {
        do {
            guard let rotationURLPolitics else { return }
            let newURL = rotationURLPolitics.nextFileURL(for: sourceURL)
            //close current file
            try fileHandle.synchronize()
            try fileHandle.close()
            // rename current file to new url
            if fileManager.fileExists(atPath: newURL.path) {
                try fileManager.removeItem(at: newURL)
            }
            try fileManager.moveItem(at: sourceURL, to: newURL)
            // create new file at source url
            try Data().write(to: sourceURL)
            fileHandle = try FileHandle(forUpdating: sourceURL)
            currentSize = Measurement(value: 0, unit: .bytes)
        } catch {
        }
    }
}
