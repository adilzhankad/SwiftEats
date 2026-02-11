import Foundation

struct DishPublic: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let image_url: String
    let category: String
    let rating: Double
    let rating_count: Int
    let restaurant_name: String
}

struct DishesPage: Codable, Hashable {
    let items: [DishPublic]
    let page: Int
    let limit: Int
    let total: Int
    let pages: Int
}
