import Foundation

struct Restaurant: Identifiable, Hashable {
    let id: String        // category
    let name: String
    let category: String
    let rating: Double
    let deliveryTime: Int
}
