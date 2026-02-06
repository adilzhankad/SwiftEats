import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItem] = []

    init() {
        items = CartStorage.shared.load()
    }

    // CREATE / UPDATE
    func add(dish: Dish, quantity: Int = 1) {
        if let idx = items.firstIndex(where: { $0.id == dish.id }) {
            items[idx].quantity += quantity
        } else {
            items.append(CartItem(id: dish.id, dish: dish, quantity: quantity))
        }
        persist()
    }

    func setQuantity(for item: CartItem, quantity: Int) {
        guard let idx = items.firstIndex(of: item) else { return }
        items[idx].quantity = max(1, quantity)
        persist()
    }

    // DELETE
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persist()
    }

    func removeAll() {
        items.removeAll()
        CartStorage.shared.clear()
    }

    // CALC (closures ✅)
    var subtotal: Double {
        items.map { $0.dish.price * Double($0.quantity) }.reduce(0, +)
    }

    var deliveryFee: Double {
        subtotal >= 30 ? 0 : 5
    }

    var total: Double {
        subtotal + deliveryFee
    }

    private func persist() {
        CartStorage.shared.save(items)
    }
}
