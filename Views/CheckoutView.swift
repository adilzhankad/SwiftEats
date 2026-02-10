//
//  CheckoutView.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var ordersVM: OrdersViewModel
    @StateObject private var vm = CheckoutViewModel()

    @Environment(\.dismiss) private var dismiss
    @State private var didPlaceOrder = false

    var body: some View {
        List {
            Section("Address") {
                TextField("Delivery address", text: $vm.addressText)
            }

            Section("Delivery time") {
                Picker("Delivery", selection: $vm.selectedDeliveryTime) {
                    ForEach(CheckoutViewModel.DeliveryTime.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.inline)
            }

            Section("Payment") {
                Picker("Payment", selection: $vm.selectedPayment) {
                    ForEach(CheckoutViewModel.PaymentMethod.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Summary") {
                row(title: "Subtotal", value: "\(String(format: "%.2f", cartVM.subtotal)) $")
                row(title: "Delivery", value: cartVM.deliveryFee == 0 ? "Free" : "\(String(format: "%.2f", cartVM.deliveryFee)) $")
                row(title: "Total", value: "\(String(format: "%.2f", cartVM.total)) $", emphasized: true)
            }

            Section {
                Button {
                    let items = cartVM.items
                    let total = cartVM.total
                    ordersVM.placeOrder(items: items, total: total)
                    cartVM.removeAll()
                    didPlaceOrder = true
                } label: {
                    Text("Place order")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(UITheme.primary)
                .disabled(cartVM.items.isEmpty)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order placed", isPresented: $didPlaceOrder) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your order has been added to Orders.")
        }
    }

    private func row(title: String, value: String, emphasized: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(emphasized ? .headline : .body)
            Spacer()
            Text(value)
                .font(emphasized ? .headline : .body)
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
            .environmentObject(CartViewModel())
            .environmentObject(OrdersViewModel())
    }
}
