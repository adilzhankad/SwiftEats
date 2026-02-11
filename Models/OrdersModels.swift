import Foundation

struct CheckoutRequest: Codable {
    let address: String
    let delivery_time: String
    let leave_at_door: Bool
    let courier_note: String?
    let payment_method: String
    let promo_code: String?
}

struct OrderCreateResponse: Codable, Identifiable {
    let id: String
    let status: String
    let created_at: Date
    let total: Double
    let eta_seconds: Int
}

struct OrderListItemPublic: Codable, Identifiable, Hashable {
    let id: String
    let status: String
    let created_at: Date
    let total: Double
    let items_count: Int
    let restaurant_name_preview: String?
}

struct OrderDetailPublic: Codable, Identifiable {
    let id: String
    let user_id: String
    let items: [CartItemPublic]
    let subtotal: Double
    let delivery_fee: Double
    let total: Double
    let address: String
    let delivery_time: String
    let leave_at_door: Bool
    let courier_note: String?
    let payment_method: String
    let status: String
    let created_at: Date
    let updated_at: Date
    let tracking_started_at: Date
    let eta_seconds: Int
}

struct OrderTrackingPublic: Codable {
    let order_id: String
    let status: String
    let progress: Double
    let eta_remaining_seconds: Int
    let steps: [String: CodableValue]
}
