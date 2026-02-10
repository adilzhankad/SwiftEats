import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject var cartVM: CartViewModel
    @State private var searchText = ""
    @State private var selectedCategory: CategoryChip = .popular

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header

                    SearchBar(text: $searchText)

                    PromoBanner(
                        titleTop: "Free Delivery",
                        title: "Hungry? We got you.\nOrder now",
                        buttonTitle: "Order Now",
                        onTap: {}
                    )

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(CategoryChip.allCases) { chip in
                                CategoryChipView(
                                    chip: chip,
                                    isSelected: chip == selectedCategory
                                ) {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                        selectedCategory = chip
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }

                    VStack(spacing: 12) {
                        ForEach(vm.filteredDishes(search: searchText, category: selectedCategory)) { dish in
                            NavigationLink {
                                DishDetailView(dish: dish)
                            } label: {
                                FoodCard(
                                    title: dish.title,
                                    subtitle: dish.category.capitalized,
                                    price: String(format: "%.2f $", dish.price),
                                    imageURL: dish.thumbnail,
                                    ratingText: String(format: "%.1f", dish.rating),
                                    isFavorite: vm.isFavorite(dish),
                                    onToggleFavorite: {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                            vm.toggleFavorite(dish)
                                        }
                                    },
                                    onAdd: {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                            cartVM.add(dish: dish)
                                        }
                                    }
                                )

                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(UITheme.bg)
            .navigationBarHidden(true)
        }
        .task { vm.load() }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Delivering to")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    Text("Home")
                        .font(.title3.weight(.bold))
                    Image(systemName: "chevron.down")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(UITheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: UITheme.shadow, radius: 14, y: 8)
            }
            .buttonStyle(.plain)
        }
    }
}
