import Foundation
import Security

@MainActor
final class TokenManager: ObservableObject {
    static let shared = TokenManager()

    @Published private(set) var accessToken: String?

    private let service = "SwiftEats"
    private let account = "access_token"

    private init() {
        accessToken = readToken()
    }

    func setAccessToken(_ token: String) {
        accessToken = token
        saveToken(token)
    }

    func clear() {
        accessToken = nil
        deleteToken()
    }

    private func saveToken(_ token: String) {
        let data = Data(token.utf8)

        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status: OSStatus
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else {
            query[kSecValueData as String] = data
            status = SecItemAdd(query as CFDictionary, nil)
        }

        if status != errSecSuccess {
            print("Keychain save token status:", status)
        }
    }

    private func readToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        guard let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete token status:", status)
        }
    }
}
