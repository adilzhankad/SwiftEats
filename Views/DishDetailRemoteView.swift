import SwiftUI

struct DishDetailRemoteView: View {
    let dishId: String

    @StateObject private var vm: DishDetailRemoteViewModel
    @EnvironmentObject var cartVM: CartViewModel

    @State private var quantity: Int = 1

    init(dishId: String) {
        self.dishId = dishId
        _vm = StateObject(wrappedValue: DishDetailRemoteViewModel(dishId: dishId))
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
            } else if let message = vm.errorMessage {
                VStack(spacing: 12) {
                    Text(message)
                        .foregroundStyle(.red)
                        .font(.footnote)
                    Button("Retry") {
                        Task { await vm.load() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(UITheme.primary)
                }
                .padding()
            } else if let dish = vm.dish {
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        AsyncImage(url: URL(string: dish.image_url)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.black.opacity(0.06))
                        }
                        .frame(height: 260)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                        VStack(alignment: .leading, spacing: 8) {
                            Text(dish.title)
                                .font(.title2.weight(.bold))

                            HStack(spacing: 10) {
                                Badge(text: "★ \(String(format: "%.1f", dish.rating))")
                                Badge(text: dish.category)
                            }

                            Text(dish.description)
                                .foregroundStyle(.secondary)
                        }

                        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...20)

                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                // Temporary: local cart model still uses Dish (DummyJSON). We will refactor cart to backend next.
                                // For now, this screen does not add to local cart.
                            }
                        } label: {
                            Text("Add to cart")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(UITheme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .disabled(true)

                        Spacer(minLength: 10)
                    }
                    .padding()
                }
                .background(UITheme.bg)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Dish")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }
}

#Preview {
    NavigationStack {
        DishDetailRemoteView(dishId: "1")
            .environmentObject(CartViewModel())
    }
}
