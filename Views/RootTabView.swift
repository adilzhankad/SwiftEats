import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house") }
            CartView().tabItem { Label("Cart", systemImage: "cart") }
            OrdersListView().tabItem { Label("Orders", systemImage: "clock") }
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
