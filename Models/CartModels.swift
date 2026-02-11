import Foundation

struct CartItemPublic: Codable, Hashable {
    let dish_id: String
    let qty: Int
    let price_snapshot: Double
    let title_snapshot: String
    let image_snapshot: String
}

struct CartResponse: Codable {
    let items: [CartItemPublic]
    let subtotal: Double
    let delivery_fee: Double
    let total: Double
}

struct CartAddItemRequest: Codable {
    let dish_id: String
    let qty: Int
}

struct CartUpdateItemRequest: Codable {
    let qty: Int
}
