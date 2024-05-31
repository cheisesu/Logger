import Foundation

public protocol FileURLRotationPolitics: Sendable {
    func nextFileURL(for source: URL) -> URL
}
