import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var dishes: [Dish] = []
    @Published var favoriteIds: Set<Int> = []

    private let favoritesKey = "favorite_dish_ids_v1"

    func load() {
        Task {
            do {
                dishes = try await APIService.shared.fetchDishes()
                loadFavorites()
            } catch {
                print(error)
            }
        }
    }

    func filteredDishes(search: String, category: CategoryChip) -> [Dish] {
        let query = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        var result = dishes

        if category != .popular {
            result = result.filter { dish in
                let cat = dish.category.lowercased()
                return cat.contains(category.rawValue.lowercased())
            }
        }

        if !query.isEmpty {
            result = result.filter { dish in
                dish.title.lowercased().contains(query) || dish.category.lowercased().contains(query)
            }
        }

        return result
    }

    func isFavorite(_ dish: Dish) -> Bool {
        favoriteIds.contains(dish.id)
    }

    func toggleFavorite(_ dish: Dish) {
        if favoriteIds.contains(dish.id) {
            favoriteIds.remove(dish.id)
        } else {
            favoriteIds.insert(dish.id)
        }
        saveFavorites()
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            favoriteIds = []
            return
        }
        do {
            let ids = try JSONDecoder().decode([Int].self, from: data)
            favoriteIds = Set(ids)
        } catch {
            favoriteIds = []
        }
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(Array(favoriteIds))
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Favorites save error:", error)
        }
    }
}
