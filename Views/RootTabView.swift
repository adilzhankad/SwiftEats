import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Dishes", systemImage: "fork.knife") }
            FavoritesView().tabItem { Label("Favorites", systemImage: "heart") }
            CartView().tabItem { Label("Cart", systemImage: "cart") }
            OrdersListView().tabItem { Label("Orders", systemImage: "clock") }
            ProfileView().tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
