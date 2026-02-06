import SwiftUI

@main
struct SwiftEatsApp: App {
    @StateObject private var cartVM = CartViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(cartVM)
        }
    }
}
