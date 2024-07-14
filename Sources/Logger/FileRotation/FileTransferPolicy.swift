import Foundation

public protocol FileLimitsPolitics: Sendable {
    var maxSize: Measurement<UnitInformationStorage> { get }
}

public protocol FileTransferPolicy: Sendable {
    func perform(for sourceURL: URL, recreateSource: Bool) throws
}

extension FileTransferPolicy {
    public func perform(for sourceURL: URL) throws {
        try perform(for: sourceURL, recreateSource: false)
    }
}
