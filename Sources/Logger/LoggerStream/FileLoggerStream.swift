import Foundation

public protocol FileLoggerStreamTransformable: Sendable {
    func transform(_ data: Data) throws -> Data
}

public struct BlockFileStreamTransformer: FileLoggerStreamTransformable {
    private let block: @Sendable (Data) throws -> Data

    public init(block: @escaping @Sendable (Data) throws -> Data) {
        self.block = block
    }

    public func transform(_ data: Data) throws -> Data {
        try block(data)
    }
}

public final class FileLoggerStream: LoggerStream, @unchecked Sendable {
    private let sourceURL: URL
    private let fileHandleLock: NSLock
    private var fileHandle: FileHandle
    private let fileManager: FileManager
    private let fileLimits: FileLimitsPolitics
    private let fileTransferPolicy: FileTransferPolicy?
    private let currentSizeLock: NSLock
    private var currentSize: Measurement<UnitInformationStorage>
    private let encoding: String.Encoding
    private let transformersLock: NSLock
    private var transformers: [FileLoggerStreamTransformable]

    public init(_ sourceURL: URL, encoding: String.Encoding = .utf8, fileManager: FileManager = .default,
                fileLimits: FileLimitsPolitics = 0, fileTransferPolicy: FileTransferPolicy? = nil) throws {
        self.sourceURL = sourceURL
        self.fileManager = fileManager
        self.fileLimits = fileLimits
        self.fileTransferPolicy = fileTransferPolicy
        self.encoding = encoding
        fileHandleLock = NSLock()
        currentSizeLock = NSLock()
        transformersLock = NSLock()
        transformers = []

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
        if currentSize >= fileLimits.maxSize {
            changeFile()
        }
    }

    deinit {
        fileHandleLock.lock()
        defer { fileHandleLock.unlock() }
        do {
            try fileHandle.close()
        } catch {
        }
    }

    public func addTransformer(_ transformer: FileLoggerStreamTransformable) {
        transformersLock.lock()
        defer { transformersLock.unlock() }
        transformers.append(transformer)
    }

    public func write(_ string: String) {
        fileHandleLock.lock()
        defer { fileHandleLock.unlock() }
        do {
            guard var data = string.data(using: encoding) else { return }
            data = try transformedData(data)
            if #available(tvOS 13.4, macOS 10.15.4, iOS 13.4, *) {
                try fileHandle.write(contentsOf: data)
            } else {
                fileHandle.write(data)
            }
            let size = Measurement(value: Double(data.count), unit: UnitInformationStorage.bytes)
            handleWriteSize(size)
        } catch {
        }
    }

    private func handleWriteSize(_ size: Measurement<UnitInformationStorage>) {
        currentSizeLock.lock()
        defer { currentSizeLock.unlock() }
        currentSize = currentSize + size
        if currentSize >= fileLimits.maxSize {
            changeFile()
        }
    }

    /// - warning: this method should be used under `fileHandle` lock and `currentSize `lock.
    private func changeFile() {
        guard let fileTransferPolicy else { return }
        do {
            try fileHandle.synchronize()
            try fileHandle.close()
            try fileTransferPolicy.perform(for: sourceURL, recreateSource: true)
            fileHandle = try FileHandle(forUpdating: sourceURL)
            currentSize = Measurement(value: 0, unit: .bytes)
        } catch {
        }
    }

    private func transformedData(_ data: Data) throws -> Data {
        transformersLock.lock()
        defer { transformersLock.unlock() }
        var data = data
        for transformer in transformers {
            data = try transformer.transform(data)
        }
        return data
    }
}
