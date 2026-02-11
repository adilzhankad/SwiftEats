import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView()
                } else if let message = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.footnote)
                        Button("Retry") {
                            Task { await vm.load() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(UITheme.primary)
                    }
                    .padding()
                } else if vm.dishes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "heart")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("No favorites")
                            .font(.title3.weight(.bold))
                        Text("Add dishes to favorites to see them here.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(vm.dishes, id: \.id) { dish in
                            NavigationLink {
                                DishDetailRemoteView(dishId: dish.id)
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: dish.image_url)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Rectangle().fill(Color.black.opacity(0.06))
                                    }
                                    .frame(width: 56, height: 56)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(dish.title)
                                            .font(.headline)
                                        Text(dish.restaurant_name)
                                            .foregroundStyle(.secondary)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }

                                    Spacer()

                                    Button {
                                        Task { await vm.remove(dishId: dish.id) }
                                    } label: {
                                        Image(systemName: "heart.slash")
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .task {
            await vm.load()
        }
        .onAppear {
            Task { await vm.load() }
        }
        .onReceive(NotificationCenter.default.publisher(for: .favoritesDidChange)) { _ in
            Task { await vm.load() }
        }
        .onChange(of: session.state) { _, newValue in
            if newValue == .authenticated {
                Task { await vm.load() }
            }
        }
    }
}

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

#Preview {
    FavoritesView()
        .environmentObject(SessionViewModel())
}
