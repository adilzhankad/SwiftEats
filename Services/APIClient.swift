import Foundation

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let tokenManager: TokenManager

    init(session: URLSession = .shared, tokenManager: TokenManager = .shared) {
        self.session = session
        self.tokenManager = tokenManager
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    func request<Response: Decodable, Body: Encodable>(
        _ method: HTTPMethod,
        path: String,
        body: Body? = nil,
        requiresAuth: Bool = true,
        responseType: Response.Type = Response.self
    ) async throws -> Response {
        let url = APIConfig.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

#if DEBUG
        print("[APIClient] \(method.rawValue) \(url.absoluteString)")
#endif

        if requiresAuth {
            guard let token = await tokenManager.accessToken, !token.isEmpty else {
                throw NetworkError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try jsonEncoder.encode(body)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.server(statusCode: -1, message: nil)
        }

        if http.statusCode == 401 {
            await tokenManager.clear()
            throw NetworkError.unauthorized
        }

        if http.statusCode == 404 {
            throw NetworkError.notFound
        }

        if http.statusCode == 422 {
            if let validation = try? jsonDecoder.decode(ValidationErrorResponse.self, from: data) {
                throw NetworkError.validation(message: validation.message())
            }
            throw NetworkError.validation(message: "Validation error")
        }

        guard (200...299).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw NetworkError.server(statusCode: http.statusCode, message: message)
        }

        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    func request<Response: Decodable>(
        _ method: HTTPMethod,
        path: String,
        requiresAuth: Bool = true,
        responseType: Response.Type = Response.self
    ) async throws -> Response {
        try await request(method, path: path, body: Optional<EmptyBody>.none, requiresAuth: requiresAuth, responseType: responseType)
    }

    func request<Body: Encodable>(
        _ method: HTTPMethod,
        path: String,
        body: Body,
        requiresAuth: Bool = true
    ) async throws {
        _ = try await request(method, path: path, body: body, requiresAuth: requiresAuth, responseType: EmptyResponse.self)
    }

    func request(
        _ method: HTTPMethod,
        path: String,
        requiresAuth: Bool = true
    ) async throws {
        _ = try await request(method, path: path, body: Optional<EmptyBody>.none, requiresAuth: requiresAuth, responseType: EmptyResponse.self)
    }

    private var jsonDecoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    private var jsonEncoder: JSONEncoder {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }
}

private struct EmptyBody: Encodable {}

private struct EmptyResponse: Decodable {}
