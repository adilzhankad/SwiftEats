import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var dishes: [Dish] = []
    @Published var favoriteDishIds: Set<String> = []

    private let dishesAPI = DishesAPI()
    private let favoritesAPI = FavoritesAPI()
    private var remoteIdByLocalId: [Int: String] = [:]

    func load() {
        Task {
            do {
                let remote = try await dishesAPI.list()
                var map: [Int: String] = [:]
                dishes = remote.compactMap { dto in
                    let id = Int(dto.id) ?? abs(dto.id.hashValue)
                    map[id] = dto.id
                    return Dish(
                        id: id,
                        title: dto.title,
                        price: dto.price,
                        thumbnail: dto.image_url,
                        category: dto.category,
                        description: dto.description,
                        rating: dto.rating
                    )
                }
                remoteIdByLocalId = map
                await loadFavoritesFromBackendIfPossible()
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
        guard let remoteId = remoteIdByLocalId[dish.id] else { return false }
        return favoriteDishIds.contains(remoteId)
    }

    func toggleFavorite(_ dish: Dish) {
        guard let remoteId = remoteIdByLocalId[dish.id] else { return }

        let willBeFavorite = !favoriteDishIds.contains(remoteId)
        if willBeFavorite {
            favoriteDishIds.insert(remoteId)
        } else {
            favoriteDishIds.remove(remoteId)
        }

        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        Task {
            do {
                if willBeFavorite {
                    try await favoritesAPI.toggle(dishId: remoteId)
                } else {
                    try await favoritesAPI.remove(dishId: remoteId)
                }
            } catch {
                // Rollback optimistic update
                if willBeFavorite {
                    favoriteDishIds.remove(remoteId)
                } else {
                    favoriteDishIds.insert(remoteId)
                }
                NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
                print(error)
            }
        }
    }

    private func loadFavoritesFromBackendIfPossible() async {
        do {
            let fav = try await favoritesAPI.get()
            favoriteDishIds = Set(fav.dish_ids)
        } catch let error as NetworkError {
            if case .unauthorized = error {
                favoriteDishIds = []
                return
            }
            print(error)
        } catch {
            print(error)
        }
    }
}
