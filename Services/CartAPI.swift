import Foundation

final class CartAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func get() async throws -> CartResponse {
        try await client.request(.get, path: "cart", requiresAuth: true, responseType: CartResponse.self)
    }

    func addItem(_ req: CartAddItemRequest) async throws {
        try await client.request(.post, path: "cart/items", body: req, requiresAuth: true)
    }

    func updateItem(dishId: String, req: CartUpdateItemRequest) async throws {
        try await client.request(.put, path: "cart/items/\(dishId)", body: req, requiresAuth: true)
    }

    func deleteItem(dishId: String) async throws {
        try await client.request(.delete, path: "cart/items/\(dishId)", requiresAuth: true)
    }

    func clear() async throws {
        try await client.request(.delete, path: "cart", requiresAuth: true)
    }
}
