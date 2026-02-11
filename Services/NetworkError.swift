import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transport(Error)
    case server(statusCode: Int, message: String?)
    case unauthorized
    case notFound
    case validation(message: String)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .transport(let error):
            return error.localizedDescription
        case .server(let statusCode, let message):
            return message ?? "Server error: \(statusCode)"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Not found"
        case .validation(let message):
            return message
        case .decoding:
            return "Failed to decode response"
        }
    }
}

struct ValidationErrorResponse: Codable {
    struct DetailItem: Codable {
        let loc: [CodableValue]?
        let msg: String?
        let type: String?
    }

    let detail: CodableValue

    func message() -> String {
        if let s = detail.stringValue {
            return s
        }

        if let arr = detail.arrayValue {
            let msgs = arr.compactMap { $0.objectValue?["msg"]?.stringValue }
            if !msgs.isEmpty {
                return msgs.joined(separator: "\n")
            }
        }

        return "Validation error"
    }
}

struct CodableValue: Codable, Hashable {
    let value: AnyHashable?

    init(_ value: AnyHashable?) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            value = nil
            return
        }
        if let b = try? container.decode(Bool.self) {
            value = b
            return
        }
        if let i = try? container.decode(Int.self) {
            value = i
            return
        }
        if let d = try? container.decode(Double.self) {
            value = d
            return
        }
        if let s = try? container.decode(String.self) {
            value = s
            return
        }
        if let a = try? container.decode([CodableValue].self) {
            value = a as AnyHashable
            return
        }
        if let o = try? container.decode([String: CodableValue].self) {
            value = o as AnyHashable
            return
        }

        value = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        guard let value else {
            try container.encodeNil()
            return
        }

        switch value {
        case let b as Bool:
            try container.encode(b)
        case let i as Int:
            try container.encode(i)
        case let d as Double:
            try container.encode(d)
        case let s as String:
            try container.encode(s)
        case let a as [CodableValue]:
            try container.encode(a)
        case let o as [String: CodableValue]:
            try container.encode(o)
        default:
            try container.encode(String(describing: value))
        }
    }

    var stringValue: String? { value as? String }
    var arrayValue: [CodableValue]? { value as? [CodableValue] }
    var objectValue: [String: CodableValue]? { value as? [String: CodableValue] }
}
