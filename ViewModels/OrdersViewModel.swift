//
//  OrdersViewModel.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import Foundation

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published private(set) var orders: [Order] = []

    init() {
        orders = OrderStorage.shared.load().sorted(by: { $0.createdAt > $1.createdAt })
    }

    func placeOrder(items: [CartItem], total: Double) {
        _ = placeOrder(items: items, total: total, status: .preparing)
    }

    @discardableResult
    func placeOrder(items: [CartItem], total: Double, status: Order.Status) -> UUID {
        let id = UUID()
        let order = Order(
            id: id,
            items: items,
            total: total,
            createdAt: Date(),
            status: status
        )

        orders.insert(order, at: 0)
        persist()
        return id
    }

    func setStatus(orderId: UUID, status: Order.Status) {
        guard let idx = orders.firstIndex(where: { $0.id == orderId }) else { return }

        let existing = orders[idx]
        orders[idx] = Order(
            id: existing.id,
            items: existing.items,
            total: existing.total,
            createdAt: existing.createdAt,
            status: status
        )
        persist()
    }

    func clearAll() {
        orders.removeAll()
        OrderStorage.shared.clear()
    }

    private func persist() {
        OrderStorage.shared.save(orders)
    }
}
