import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var ordersVM: OrdersViewModel
    @State private var isPlacingOrder: Bool = false
    @State private var courierProgress: CGFloat = 0
    @State private var isDelivered: Bool = false

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

                        Section {
                            Button {
                                Task { await placeOrderFlow() }
                            } label: {
                                Text("Make order")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(UITheme.primary)
                            .disabled(isPlacingOrder)
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
        .overlay {
            if isPlacingOrder {
                CourierOverlay(progress: courierProgress, isDelivered: isDelivered)
                    .transition(.opacity)
            }
        }
    }

    private func placeOrderFlow() async {
        guard !cartVM.items.isEmpty else { return }

        isPlacingOrder = true
        isDelivered = false
        courierProgress = 0

        let orderId = ordersVM.placeOrder(items: cartVM.items, total: cartVM.total, status: .preparing)
        ordersVM.setStatus(orderId: orderId, status: .onTheWay)

        await MainActor.run {
            withAnimation(.linear(duration: 30)) {
                courierProgress = 1
            }
        }

        try? await Task.sleep(nanoseconds: 30_000_000_000)

        ordersVM.setStatus(orderId: orderId, status: .delivered)
        await MainActor.run {
            isDelivered = true
        }

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        await MainActor.run {
            withAnimation { cartVM.removeAll() }
            isPlacingOrder = false
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

private struct CourierOverlay: View {
    let progress: CGFloat
    let isDelivered: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(isDelivered ? "Delivered" : "Courier is on the way")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                GeometryReader { geo in
                    let width = geo.size.width
                    let x = (1 - progress) * width

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.black.opacity(0.06))
                            .frame(height: 64)

                        Image(systemName: isDelivered ? "checkmark.circle.fill" : "bicycle")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(isDelivered ? .green : UITheme.primary)
                            .offset(x: max(0, min(width - 44, x)) + 14)
                    }
                }
                .frame(height: 64)
                .padding(.horizontal)
            }
            .padding(20)
            .frame(maxWidth: 420)
            .background(UITheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: UITheme.shadow, radius: 22, y: 12)
            .padding()
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartViewModel())
}
