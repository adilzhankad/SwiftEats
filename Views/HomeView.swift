import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading…")
                } else if let err = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error").font(.headline)
                        Text(err).multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await vm.load() }
                        }
                    }
                    .padding()
                } else {
                    List(vm.restaurants) { r in
                        NavigationLink(value: r) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(r.name).font(.headline)
                                    Text("⭐️ \(String(format: "%.1f", r.rating)) • \(r.deliveryTime) min")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Restaurants")
            .searchable(text: $vm.searchText)
            .onChange(of: vm.searchText) { _, _ in vm.applySortAndFilter() }
            .toolbar {
                Menu {
                    Picker("Sort", selection: $vm.sortMode) {
                        ForEach(HomeViewModel.SortMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .onChange(of: vm.sortMode) { _, _ in vm.applySortAndFilter() }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            .navigationDestination(for: Restaurant.self) { r in
                RestaurantMenuView(restaurant: r, allDishes: vm.dishes)
            }
            .task {
                if vm.dishes.isEmpty { await vm.load() }
            }
        }
    }
}
