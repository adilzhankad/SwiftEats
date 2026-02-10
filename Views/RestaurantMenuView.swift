import SwiftUI

struct RestaurantMenuView: View {
    let restaurant: Restaurant
    let allDishes: [Dish]

    private var dishesForRestaurant: [Dish] {
        allDishes.filter { $0.category.lowercased().contains(restaurant.category.lowercased()) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(dishesForRestaurant) { dish in
                    NavigationLink {
                        DishDetailView(dish: dish)
                    } label: {
                        FoodCard(
                            title: dish.title,
                            subtitle: restaurant.name,
                            price: "\(String(format: "%.2f", dish.price)) $",
                            imageURL: dish.thumbnail,
                            ratingText: "\(String(format: "%.1f", dish.rating))",
                            isFavorite: false,
                            onToggleFavorite: {},
                            onAdd: {}
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(UITheme.bg)
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
