import Foundation

struct Dish: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let category: String
    let thumbnail: String
}
