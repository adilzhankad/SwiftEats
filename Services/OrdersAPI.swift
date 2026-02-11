import Foundation

final class OrdersAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func create(_ req: CheckoutRequest) async throws -> OrderCreateResponse {
        try await client.request(.post, path: "orders", body: req, requiresAuth: true, responseType: OrderCreateResponse.self)
    }

    func list() async throws -> [OrderListItemPublic] {
        try await client.request(.get, path: "orders", requiresAuth: true, responseType: [OrderListItemPublic].self)
    }

    func detail(orderId: String) async throws -> OrderDetailPublic {
        try await client.request(.get, path: "orders/\(orderId)", requiresAuth: true, responseType: OrderDetailPublic.self)
    }

    func cancel(orderId: String) async throws {
        try await client.request(.patch, path: "orders/\(orderId)/cancel", requiresAuth: true)
    }

    func tracking(orderId: String) async throws -> OrderTrackingPublic {
        try await client.request(.get, path: "orders/\(orderId)/tracking", requiresAuth: true, responseType: OrderTrackingPublic.self)
    }
}
