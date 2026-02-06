import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var restaurants: [Restaurant] = []
    @Published var dishes: [Dish] = []

    // filters
    @Published var searchText: String = ""
    @Published var sortMode: SortMode = .name

    enum SortMode: String, CaseIterable, Identifiable {
        case name = "Name"
        case rating = "Rating"
        case delivery = "Delivery"
        var id: String { rawValue }
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let items = try await APIService.shared.fetchDishes()
            dishes = items
            restaurants = buildRestaurants(from: items)
            applySortAndFilter()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func applySortAndFilter() {
        var list = buildRestaurants(from: dishes)

        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchText.lowercased()
            list = list.filter { $0.name.lowercased().contains(q) }   // closure-based op ✅
        }

        switch sortMode {
        case .name:
            list = list.sorted { $0.name < $1.name }                 // closure ✅
        case .rating:
            list = list.sorted { $0.rating > $1.rating }
        case .delivery:
            list = list.sorted { $0.deliveryTime < $1.deliveryTime }
        }

        restaurants = list
    }

    private func buildRestaurants(from dishes: [Dish]) -> [Restaurant] {
        let categories = Array(Set(dishes.map { $0.category }))       // map + Set ✅
        let list = categories.map { cat in
            Restaurant(
                id: cat,
                name: cat.capitalized,
                category: cat,
                rating: Double.random(in: 4.0...5.0),
                deliveryTime: Int.random(in: 15...55)
            )
        }
        return list
    }
}
