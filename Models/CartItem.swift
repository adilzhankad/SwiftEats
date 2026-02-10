import Foundation

struct CartItem: Identifiable, Codable {
    let id: Int
    let dish: Dish
    var quantity: Int
}
