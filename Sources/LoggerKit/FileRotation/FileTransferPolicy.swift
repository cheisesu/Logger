import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol FileLimitsPolitics: Sendable {
    var maxSize: Measurement<UnitInformationStorage> { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public protocol FileTransferPolicy: Sendable {
    func perform(for sourceURL: URL, recreateSource: Bool) throws
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension FileTransferPolicy {
    public func perform(for sourceURL: URL) throws {
        try perform(for: sourceURL, recreateSource: false)
    }
}
