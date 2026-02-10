import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel

    var body: some View {
        NavigationStack {
            Group {
                if cartVM.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("Cart is empty")
                            .font(.title3.weight(.bold))
                        Text("Add dishes to make an order.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section("Items") {
                            ForEach(cartVM.items) { item in
                                CartItemRow(item: item)
                            }
                            .onDelete { offsets in
                                withAnimation {
                                    cartVM.remove(at: offsets)
                                }
                            }
                        }

                        Section("Summary") {
                            SummaryRow(title: "Subtotal", value: "\(String(format: "%.2f", cartVM.subtotal)) $")
                            SummaryRow(
                                title: "Delivery",
                                value: cartVM.deliveryFee == 0
                                    ? "Free"
                                    : "\(String(format: "%.2f", cartVM.deliveryFee)) $"
                            )
                            SummaryRow(
                                title: "Total",
                                value: "\(String(format: "%.2f", cartVM.total)) $",
                                isEmphasized: true
                            )
                        }
                    }
                }
            }
            .navigationTitle("Cart")
            .background(UITheme.bg)
            .toolbar {
                if !cartVM.items.isEmpty {
                    Button("Clear") {
                        withAnimation { cartVM.removeAll() }
                    }
                }
            }
        }
    }

    private func CartItemRow(item: CartItem) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.dish.title)
                    .font(.headline)

                Text("\(item.dish.price, specifier: "%.2f") $")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Stepper(
                value: Binding(
                    get: {
                        cartVM.items.first(where: { $0.id == item.id })?.quantity ?? item.quantity
                    },
                    set: { newValue in
                        withAnimation {
                            cartVM.setQuantity(for: item, quantity: newValue)
                        }
                    }
                ),
                in: 1...20
            ) {
                Text("\(item.quantity)")
                    .frame(width: 28)
            }
            .labelsHidden()
        }
        .padding(.vertical, 6)
    }

    private func SummaryRow(title: String, value: String, isEmphasized: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(isEmphasized ? .headline : .body)
            Spacer()
            Text(value)
                .font(isEmphasized ? .headline : .body)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
}
