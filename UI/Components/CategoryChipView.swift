import SwiftUI

enum CategoryChip: String, CaseIterable, Identifiable {
    case popular = "Popular"
    case pizza = "Pizza"
    case burgers = "Burgers"
    case healthy = "Healthy"
    case sushi = "Sushi"
    case dessert = "Dessert"
    var id: String { rawValue }
}

struct CategoryChipView: View {
    let chip: CategoryChip
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(chip.rawValue)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? UITheme.primary.opacity(0.18) : Color.black.opacity(0.05))
            .foregroundStyle(isSelected ? UITheme.primaryDarker : .primary)
            .clipShape(Capsule())
            .onTapGesture { onTap() }
    }
}
