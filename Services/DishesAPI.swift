import Foundation

final class DishesAPI {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func list(category: String? = nil, page: Int? = nil, limit: Int? = nil) async throws -> [DishPublic] {
        var path = "dishes"
        var query: [String] = []
        if let category, !category.isEmpty {
            query.append("category=\(category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category)")
        }
        if let page {
            query.append("page=\(page)")
        }
        if let limit {
            query.append("limit=\(limit)")
        }
        if !query.isEmpty {
            path += "?" + query.joined(separator: "&")
        }

        let resp = try await client.request(.get, path: path, requiresAuth: false, responseType: DishesPage.self)
        return resp.items
    }

    func get(dishId: String) async throws -> DishPublic {
        try await client.request(.get, path: "dishes/\(dishId)", requiresAuth: false, responseType: DishPublic.self)
    }
}
