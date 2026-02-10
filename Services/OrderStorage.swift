import Foundation

final class OrderStorage {
    static let shared = OrderStorage()
    private init() {}

    private let key = "orders_v1"

    func save(_ orders: [Order]) {
        do {
            let data = try JSONEncoder().encode(orders)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Orders save error:", error)
        }
    }

    func load() -> [Order] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Order].self, from: data)
        } catch {
            print("Orders load error:", error)
            return []
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
