import Foundation

final class FavoritesAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func get() async throws -> FavoritesResponse {
        try await client.request(.get, path: "favorites", requiresAuth: true, responseType: FavoritesResponse.self)
    }

    func toggle(dishId: String) async throws {
        try await client.request(.post, path: "favorites/\(dishId)", requiresAuth: true)
    }

    func remove(dishId: String) async throws {
        try await client.request(.delete, path: "favorites/\(dishId)", requiresAuth: true)
    }
}
