import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    func submit(session: SessionViewModel) async {
        errorMessage = nil

        if password.utf8.count > 72 {
            errorMessage = "Password is too long (max 72 bytes)"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await session.register(name: name, email: email, password: password)
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
