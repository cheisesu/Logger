import Foundation

final class _ErrorFileManager: FileManager {
    enum Error: Swift.Error {
        case justAnError
    }

    override func removeItem(at URL: URL) throws {
        throw Error.justAnError
    }

    override func removeItem(atPath path: String) throws {
        throw Error.justAnError
    }

    override func moveItem(at srcURL: URL, to dstURL: URL) throws {
        throw Error.justAnError
    }

    override func moveItem(atPath srcPath: String, toPath dstPath: String) throws {
        throw Error.justAnError
    }

    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        throw Error.justAnError
    }

    override func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        throw Error.justAnError
    }
}
