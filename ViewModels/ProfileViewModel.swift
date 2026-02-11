import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: UserPublic?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let authAPI: AuthAPI

    init(authAPI: AuthAPI = AuthAPI()) {
        self.authAPI = authAPI
    }

    func load() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            user = try await authAPI.me()
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
