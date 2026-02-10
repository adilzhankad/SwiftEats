import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var ordersVM: OrdersViewModel

    @AppStorage("settings_dark_mode_v1") private var isDarkMode: Bool = false
    @AppStorage("settings_location_v1") private var location: String = "Home"

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                Section("Location") {
                    TextField("Location", text: $location)
                }

                Section {
                    Button(role: .destructive) {
                        cartVM.removeAll()
                        ordersVM.clearAll()
                        UserDefaults.standard.removeObject(forKey: "favorite_dish_ids_v1")
                    } label: {
                        Text("Clear all saved data")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CartViewModel())
        .environmentObject(OrdersViewModel())
}
