import SwiftUI

struct OrdersListView: View {
    @EnvironmentObject var ordersVM: OrdersViewModel

    var body: some View {
        NavigationStack {
            Group {
                if ordersVM.orders.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("No orders yet")
                            .font(.title3.weight(.bold))
                        Text("Place an order from your cart to see it here.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(ordersVM.orders) { order in
                            NavigationLink {
                                OrderDetailView(order: order)
                            } label: {
                                OrderRow(order: order)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }

    private func OrderRow(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(order.title)
                    .font(.headline)
                Spacer()
                Badge(text: order.status.rawValue)
            }

            Text("\(order.items.count) items • \(order.total, specifier: "%.2f") $")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    OrdersListView()
        .environmentObject(OrdersViewModel())
}
