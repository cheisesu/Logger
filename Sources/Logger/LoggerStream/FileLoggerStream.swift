import Foundation

public final class FileLoggerStream: LoggerStream {
    private let sourceURL: URL
    private var fileHandle: FileHandle
    private let fileManager: FileManager
    private let lock: NSLock
    private let fileLimits: FileLimitsPolitics
    private let rotationURLPolitics: FileURLRotationPolitics?
    private var currentSize: Measurement<UnitInformationStorage>

    public init(_ sourceURL: URL, fileManager: FileManager = .default,
                fileLimits: FileLimitsPolitics = 0, rotationURLPolitics: FileURLRotationPolitics? = nil) throws {
        self.sourceURL = sourceURL
        self.fileManager = fileManager
        lock = NSLock()
        self.fileLimits = fileLimits
        self.rotationURLPolitics = rotationURLPolitics

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
        do {
            flush()
            try fileHandle.close()
        } catch {
        }
    }

    public func write(_ string: String) {
        let string = string + "\n"
        lock.lock()
        defer { lock.unlock() }
        do {
            let data = Data(string.utf8)
            let size = Measurement(value: Double(data.count), unit: UnitInformationStorage.bytes)
            if #available(tvOS 13.4, macOS 10.15.4, iOS 13.4, *) {
                try fileHandle.write(contentsOf: data)
            } else {
                fileHandle.write(data)
            }
            currentSize = currentSize + size
            if currentSize >= fileLimits.maxSize {
                changeFile()
            }
        } catch {
        }
    }

    public func flush() {
        lock.lock()
        lock.unlock()
    }

    private func changeFile() {
        guard let rotationURLPolitics else { return }
        let newURL = rotationURLPolitics.nextFileURL(for: sourceURL)
        do {
            //close current file
            try fileHandle.synchronize()
            fileHandle.closeFile()
            // rename current file to new url
            if fileManager.fileExists(atPath: newURL.path) {
                try fileManager.removeItem(at: newURL)
            }
            _ = try fileManager.moveItem(at: sourceURL, to: newURL)
            // create new file at source url
            try Data().write(to: sourceURL)
            fileHandle = try FileHandle(forUpdating: sourceURL)
            currentSize = Measurement(value: 0, unit: .bytes)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
