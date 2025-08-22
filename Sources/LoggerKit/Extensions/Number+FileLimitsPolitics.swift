import Foundation

// MARK: - UNSIGNED INTS

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension UInt64: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension UInt32: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension UInt16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension UInt8: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension UInt: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

// MARK: - SIGNED INTS

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Int64: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Int32: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Int16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Int8: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Int: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        let bytes = Double(self)
        return Measurement(value: bytes, unit: .bytes)
    }
}

// MARK: - FLOATS

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Double: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: self, unit: .bytes)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension Float: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: Double(self), unit: .bytes)
    }
}

@available(macOS 11.0, tvOS 14.0, iOS 14.0, *)
extension Float16: FileLimitsPolitics {
    public var maxSize: Measurement<UnitInformationStorage> {
        return Measurement(value: Double(self), unit: .bytes)
    }
}
