import Foundation

final class AuthAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func register(_ req: RegisterRequest) async throws -> UserPublic {
#if DEBUG
        print("[AuthAPI.register] Password chars:", req.password.count)
        print("[AuthAPI.register] Password bytes:", req.password.utf8.count)
        if let data = try? JSONEncoder().encode(req), let json = String(data: data, encoding: .utf8) {
            print("[AuthAPI.register] JSON body:", json)
        }
#endif
        return try await client.request(.post, path: "auth/register", body: req, requiresAuth: false, responseType: UserPublic.self)
    }

    func login(_ req: LoginRequest) async throws -> TokenResponse {
#if DEBUG
        print("[AuthAPI.login] Password chars:", req.password.count)
        print("[AuthAPI.login] Password bytes:", req.password.utf8.count)
        if let data = try? JSONEncoder().encode(req), let json = String(data: data, encoding: .utf8) {
            print("[AuthAPI.login] JSON body:", json)
        }
#endif
        return try await client.request(.post, path: "auth/login", body: req, requiresAuth: false, responseType: TokenResponse.self)
    }

    func token(_ req: LoginRequest) async throws -> TokenResponse {
        try await client.request(.post, path: "auth/token", body: req, requiresAuth: false, responseType: TokenResponse.self)
    }

    func me() async throws -> UserPublic {
        try await client.request(.get, path: "auth/me", requiresAuth: true, responseType: UserPublic.self)
    }
}
