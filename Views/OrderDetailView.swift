//
//  OrderDetailView.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        List {
            Section("Status") {
                HStack {
                    Text("Status")
                    Spacer()
                    Badge(text: order.status.rawValue)
                }
                HStack {
                    Text("Placed")
                    Spacer()
                    Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }

            Section("Items") {
                ForEach(order.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.dish.title)
                                .font(.headline)
                            Text("Qty: \(item.quantity)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        Spacer()
                        Text("\(item.dish.price * Double(item.quantity), specifier: "%.2f") $")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.vertical, 2)
                }
            }

            Section("Summary") {
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text("\(order.total, specifier: "%.2f") $")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(
            order: Order(
                id: UUID(),
                items: [
                    CartItem(
                        id: 1,
                        dish: Dish(
                            id: 1,
                            title: "Dish",
                            price: 9.99,
                            thumbnail: "",
                            category: "Pizza",
                            description: "Yummy",
                            rating: 4.6
                        ),
                        quantity: 2
                    )
                ],
                total: 19.98,
                createdAt: Date(),
                status: .preparing
            )
        )
    }
}
