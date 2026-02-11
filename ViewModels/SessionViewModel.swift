import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    enum State: Equatable {
        case checking
        case unauthenticated
        case authenticated
    }

    @Published private(set) var state: State = .checking
    @Published private(set) var me: UserPublic?

    private let authAPI: AuthAPI
    private let tokenManager: TokenManager

    init(authAPI: AuthAPI = AuthAPI(), tokenManager: TokenManager = .shared) {
        self.authAPI = authAPI
        self.tokenManager = tokenManager

        if tokenManager.accessToken?.isEmpty == false {
            state = .authenticated
        } else {
            state = .unauthenticated
        }
    }

    func refreshMe() async {
        guard tokenManager.accessToken?.isEmpty == false else {
            me = nil
            state = .unauthenticated
            return
        }

        do {
            let user = try await authAPI.me()
            me = user
            state = .authenticated
        } catch let error as NetworkError {
            if case .unauthorized = error {
                logout()
            }
        } catch {
            // Keep state; UI can show retry.
        }
    }

    func login(email: String, password: String) async throws {
        let token = try await authAPI.login(LoginRequest(email: email, password: password))
        tokenManager.setAccessToken(token.access_token)
        state = .authenticated
        await refreshMe()
    }

    func register(name: String, email: String, password: String) async throws {
        _ = try await authAPI.register(RegisterRequest(name: name, email: email, password: password))
        let token = try await authAPI.login(LoginRequest(email: email, password: password))
        tokenManager.setAccessToken(token.access_token)
        state = .authenticated
        await refreshMe()
    }

    func logout() {
        tokenManager.clear()
        me = nil
        state = .unauthenticated
    }

}
