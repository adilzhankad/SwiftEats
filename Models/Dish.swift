import Foundation

struct Dish: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let thumbnail: String
    let category: String
    let description: String
    let rating: Double

    init(
        id: Int,
        title: String,
        price: Double,
        thumbnail: String,
        category: String,
        description: String,
        rating: Double
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.thumbnail = thumbnail
        self.category = category
        self.description = description
        self.rating = rating
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case thumbnail
        case category
        case description
        case rating
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        let id = try c.decode(Int.self, forKey: .id)
        let title = (try? c.decode(String.self, forKey: .title)) ?? "Untitled"
        let price = (try? c.decode(Double.self, forKey: .price)) ?? 0
        let thumbnail = (try? c.decode(String.self, forKey: .thumbnail)) ?? ""
        let category = (try? c.decode(String.self, forKey: .category)) ?? "Popular"
        let description = (try? c.decode(String.self, forKey: .description)) ?? "No description available"

        let decodedRating = (try? c.decode(Double.self, forKey: .rating))
        let rating = decodedRating ?? Double((id % 20) + 30) / 10.0

        self.init(
            id: id,
            title: title,
            price: price,
            thumbnail: thumbnail,
            category: category,
            description: description,
            rating: rating
        )
    }
}
