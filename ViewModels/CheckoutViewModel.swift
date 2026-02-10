//
//  CheckoutViewModel.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import Foundation

@MainActor
final class CheckoutViewModel: ObservableObject {
    enum DeliveryTime: String, CaseIterable, Identifiable {
        case asap = "ASAP (20–30 min)"
        case inOneHour = "In 1 hour"
        case tonight = "Tonight"
        var id: String { rawValue }
    }

    enum PaymentMethod: String, CaseIterable, Identifiable {
        case card = "Card"
        case applePay = "Apple Pay"
        case cash = "Cash"
        var id: String { rawValue }
    }

    @Published var addressText: String = "221B Baker Street"
    @Published var selectedDeliveryTime: DeliveryTime = .asap
    @Published var selectedPayment: PaymentMethod = .card
}
