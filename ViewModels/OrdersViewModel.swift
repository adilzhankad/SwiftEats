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
        let order = Order(
            id: UUID(),
            items: items,
            total: total,
            createdAt: Date(),
            status: .preparing
        )

        orders.insert(order, at: 0)
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
