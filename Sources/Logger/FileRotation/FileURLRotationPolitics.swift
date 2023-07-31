import Foundation

public protocol FileURLRotationPolitics {
    func nextFileURL(for source: URL) -> URL
}
