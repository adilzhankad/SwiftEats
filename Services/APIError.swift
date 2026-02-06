import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case badResponse(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badResponse(let code):
            return "Server error: \(code)"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}
