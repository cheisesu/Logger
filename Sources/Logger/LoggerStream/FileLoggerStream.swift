import Foundation

public final class FileLoggerStream: LoggerStream {
    private let sourceURL: URL
    private let fileHandle: FileHandle
    private let fileManager: FileManager

    public init(_ sourceURL: URL, fileManager: FileManager = .default) throws {
        self.sourceURL = sourceURL
        self.fileManager = fileManager

        if !fileManager.fileExists(atPath: sourceURL.path) {
            try Data().write(to: sourceURL)
        }
        fileHandle = try FileHandle(forUpdating: sourceURL)
        if #available(macOS 10.15.4, iOS 13.4, tvOS 13.4, *) {
            _ = try fileHandle.readToEnd()
        } else {
            _ = fileHandle.readDataToEndOfFile()
        }
    }

    deinit {
        do {
            try fileHandle.close()
        } catch {
        }
    }

    public func write(_ string: String) {
        do {
            let data = Data(string.utf8)
            if #available(tvOS 13.4, *) {
                try fileHandle.write(contentsOf: data)
            } else {
                fileHandle.write(data)
            }
        } catch {
        }
    }

    public func flush() {
        do {
            try fileHandle.synchronize()
        } catch {
        }
    }
}
