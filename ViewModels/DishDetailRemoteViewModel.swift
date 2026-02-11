import Foundation

@MainActor
final class DishDetailRemoteViewModel: ObservableObject {
    @Published private(set) var dish: DishPublic?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dishesAPI: DishesAPI
    private let dishId: String

    init(dishId: String, dishesAPI: DishesAPI = DishesAPI()) {
        self.dishId = dishId
        self.dishesAPI = dishesAPI
    }

    func load() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            dish = try await dishesAPI.get(dishId: dishId)
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
