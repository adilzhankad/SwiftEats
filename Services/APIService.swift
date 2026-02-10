import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    func fetchDishes() async throws -> [Dish] {
        var components = URLComponents(string: "https://dummyjson.com/products")
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "100")
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse(-1)
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.badResponse(http.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(ProductsResponse.self, from: data)
            return decoded.products
        } catch {
            throw APIError.decodingFailed
        }
    }
}
