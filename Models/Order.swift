//
//  Order.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import Foundation

struct Order: Identifiable, Codable {
    enum Status: String, Codable {
        case preparing = "Preparing"
        case onTheWay = "On the way"
        case delivered = "Delivered"
    }

    let id: UUID
    let items: [CartItem]
    let total: Double
    let createdAt: Date
    let status: Status

    var title: String {
        items.first?.dish.category.capitalized ?? "Order"
    }
}
