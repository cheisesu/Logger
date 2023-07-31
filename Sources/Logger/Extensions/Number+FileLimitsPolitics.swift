import Foundation

// MARK: - UNSIGNED INTS

extension UInt64: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension UInt32: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension UInt16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension UInt8: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension UInt: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

// MARK: - SIGNED INTS

extension Int64: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension Int32: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension Int16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension Int8: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

extension Int: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

// MARK: - FLOATS

extension Double: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: self, unit: .bytes)
    }
}

extension Float: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: Double(self), unit: .bytes)
    }
}

@available(tvOS 14.0, *)
extension Float16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: Double(self), unit: .bytes)
    }
}
