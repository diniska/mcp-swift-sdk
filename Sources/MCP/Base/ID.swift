import struct Foundation.UUID

/// A unique identifier for a request.
public enum ID: Hashable, Sendable {
    /// A string ID.
    case string(String)

    /// A number ID.
    case number(Int)
}

// MARK: - Generation

extension ID {
    /// Generates a random string ID.
    public static var randomString: ID {
        return .string(UUID().uuidString)
    }
    
    /// Generates a random number ID.
    public static var randomNumber: ID {
        return .number(.random(in: 0 ..< .max))
    }
    
    /// Generates a new random ID value keeping the ID type
    public func randomized() -> ID {
        switch self {
        case .string: return .randomString
        case .number: return .randomNumber
        }
    }
}

// MARK: - ExpressibleByStringLiteral

extension ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension ID: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(value)
    }
}

// MARK: - CustomStringConvertible

extension ID: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let str): return str
        case .number(let num): return String(num)
        }
    }
}

// MARK: - Codable

extension ID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Int.self) {
            self = .number(number)
        } else if container.decodeNil() {
            // Handle unspecified/null IDs as empty string
            self = .string("")
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "ID must be string or number")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let str): try container.encode(str)
        case .number(let num): try container.encode(num)
        }
    }
}
