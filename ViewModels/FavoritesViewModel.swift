import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favoriteDishIds: Set<String> = []
    @Published private(set) var dishes: [DishPublic] = []

    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let favoritesAPI: FavoritesAPI
    private let dishesAPI: DishesAPI

    init(favoritesAPI: FavoritesAPI = FavoritesAPI(), dishesAPI: DishesAPI = DishesAPI()) {
        self.favoritesAPI = favoritesAPI
        self.dishesAPI = dishesAPI
    }

    func load() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let fav = try await favoritesAPI.get()
            favoriteDishIds = Set(fav.dish_ids)

            // Contract doesn't provide a bulk-by-ids endpoint, so we fetch all dishes and filter client-side.
            let all = try await dishesAPI.list()
            dishes = all.filter { favoriteDishIds.contains($0.id) }
        } catch let error as NetworkError {
#if DEBUG
            print("[FavoritesViewModel] load error:", error)
#endif
            if case .unauthorized = error {
                errorMessage = "Please sign in to view favorites."
                favoriteDishIds = []
                dishes = []
                return
            }
            errorMessage = error.localizedDescription
        } catch {
#if DEBUG
            print("[FavoritesViewModel] load error:", error)
#endif
            errorMessage = error.localizedDescription
        }
    }

    func remove(dishId: String) async {
        errorMessage = nil
        do {
            try await favoritesAPI.remove(dishId: dishId)
            favoriteDishIds.remove(dishId)
            dishes.removeAll(where: { $0.id == dishId })
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
