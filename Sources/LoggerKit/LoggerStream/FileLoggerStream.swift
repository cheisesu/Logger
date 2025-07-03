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

public final class FileLoggerStream: @unchecked Sendable {
    private let accessQueue: DispatchQueue
    private let sourceURL: URL
    private var fileHandle: FileHandle
    private let fileManager: FileManager
    private let fileLimits: FileLimitsPolitics
    private let fileTransferPolicy: FileTransferPolicy?
    private var currentSize: Measurement<UnitInformationStorage>
    private let encoding: String.Encoding
    private var transformers: [FileLoggerStreamTransformable]

    public init(_ sourceURL: URL, encoding: String.Encoding = .utf8, fileManager: FileManager = .default,
                fileLimits: FileLimitsPolitics = 0, fileTransferPolicy: FileTransferPolicy? = nil) throws {
        accessQueue = DispatchQueue(label: "com.loggerkit.stream.file")
        self.sourceURL = sourceURL
        self.fileManager = fileManager
        self.fileLimits = fileLimits
        self.fileTransferPolicy = fileTransferPolicy
        self.encoding = encoding
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
        try? fileHandle.close()
    }

    public func addTransformer(_ transformer: FileLoggerStreamTransformable) {
        accessQueue.async { [weak self] in
            self?.transformers.append(transformer)
        }
    }
}

// MARK: - LOGGER STREAM CONFORMANCE

extension FileLoggerStream: LoggerStream {
    public func write(_ string: String) {
        accessQueue.sync {
            performWrite(string)
        }
    }
}

// MARK: - ASYNC LOGGER STREAM CONFORMANCE

extension FileLoggerStream: AsyncLoggerStream {
    public func writeAsync(_ string: String) async {
        return await withCheckedContinuation { continuation in
            accessQueue.async { [weak self] in
                self?.performWrite(string)
                continuation.resume()
            }
        }
    }
}

// MARK: - PRIVATE METHODS

extension FileLoggerStream {
    private func performWrite(_ string: String) {
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
        var data = data
        for transformer in transformers {
            data = try transformer.transform(data)
        }
        return data
    }
}
