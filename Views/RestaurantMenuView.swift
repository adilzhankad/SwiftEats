import SwiftUI

struct RestaurantMenuView: View {
    let restaurant: Restaurant
    let allDishes: [Dish]

    private var dishes: [Dish] {
        allDishes.filter { $0.category == restaurant.category }
    }

    var body: some View {
        List {
            Section("Menu") {
                ForEach(dishes) { d in
                    NavigationLink {
                        DishDetailView(dish: d)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(d.title).font(.headline)
                            Text(d.description)
                                .lineLimit(2)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(d.price, specifier: "%.2f") $")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle(restaurant.name)
    }
}
