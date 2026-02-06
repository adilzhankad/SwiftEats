import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel

    var body: some View {
        NavigationStack {
            Group {
                if cartVM.items.isEmpty {
                    ContentUnavailableView("Cart is empty", systemImage: "cart", description: Text("Add dishes to make an order."))
                } else {
                    List {
                        Section("Items") {
                            ForEach(cartVM.items) { item in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.dish.title).font(.headline)
                                        Text("\(item.dish.price, specifier: "%.2f") $").foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Stepper(
                                        value: Binding(
                                            get: { item.quantity },
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
                            .onDelete { offsets in
                                withAnimation {
                                    cartVM.remove(at: offsets)
                                }
                            }
                        }

                        Section("Summary") {
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("\(cartVM.subtotal, specifier: "%.2f") $")
                            }
                            HStack {
                                Text("Delivery")
                                Spacer()
                                Text(cartVM.deliveryFee == 0 ? "Free" : "\(cartVM.deliveryFee, specifier: "%.2f") $")
                            }
                            HStack {
                                Text("Total").font(.headline)
                                Spacer()
                                Text("\(cartVM.total, specifier: "%.2f") $").font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                if !cartVM.items.isEmpty {
                    Button("Clear") {
                        withAnimation { cartVM.removeAll() }
                    }
                }
            }
        }
    }
}
