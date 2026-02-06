import SwiftUI

struct DishDetailView: View {
    let dish: Dish
    @EnvironmentObject var cartVM: CartViewModel

    @State private var quantity: Int = 1
    @State private var spicy: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(dish.title).font(.title2).bold()
            Text(dish.description).foregroundStyle(.secondary)

            Toggle("Spicy", isOn: $spicy)
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...20)

            Button {
                withAnimation {
                    cartVM.add(dish: dish, quantity: quantity)
                }
            } label: {
                Text("Add to cart • \(dish.price * Double(quantity), specifier: "%.2f") $")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Dish")
        .navigationBarTitleDisplayMode(.inline)
    }
}
