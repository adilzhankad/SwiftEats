import Foundation

final class CategoriesAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func list() async throws -> [CategoryPublic] {
        try await client.request(.get, path: "categories", requiresAuth: true, responseType: [CategoryPublic].self)
    }
}
