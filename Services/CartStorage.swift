import Foundation

final class CartStorage {
    static let shared = CartStorage()
    private init() {}

    private let key = "cart_items_v1"

    func save(_ items: [CartItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Cart save error:", error)
        }
    }

    func load() -> [CartItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([CartItem].self, from: data)
        } catch {
            print("Cart load error:", error)
            return []
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
