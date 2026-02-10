import SwiftUI

@main
struct SwiftEatsApp: App {
    @StateObject private var cartVM = CartViewModel()
    @StateObject private var ordersVM = OrdersViewModel()
    @AppStorage("settings_dark_mode_v1") private var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(cartVM)
                .environmentObject(ordersVM)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
