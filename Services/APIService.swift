import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    func fetchDishes() async throws -> [Dish] {
        guard let url = URL(string: "https://dummyjson.com/c/a795-9c36-4b7c-84b3") else {
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
