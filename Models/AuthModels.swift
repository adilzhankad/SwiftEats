import Foundation

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
}

struct UserPublic: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
}
