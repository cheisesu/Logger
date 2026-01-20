import Foundation

extension DispatchQueue {
    typealias _SafeKey = DispatchSpecificKey<ObjectIdentifier>

    func _registerSafe() -> _SafeKey {
        let key = _SafeKey()
        setSpecific(key: key, value: ObjectIdentifier(self))
        return key
    }

    @discardableResult
    func _safeSync<T>(on key: _SafeKey, _ block: () throws -> T) rethrows -> T {
        if DispatchQueue.getSpecific(key: key) == ObjectIdentifier(self) {
            return try block()
        } else {
            return try sync {
                return try block()
            }
        }
    }
}
