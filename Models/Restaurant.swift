import Foundation

struct Restaurant: Identifiable, Hashable {
    let id: Int
    let name: String
    let category: String
    let image: String?
    let deliveryTimeText: String?
    let rating: Double
}
