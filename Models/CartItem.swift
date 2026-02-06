import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    let id: Int          // dish.id
    let dish: Dish
    var quantity: Int
}
