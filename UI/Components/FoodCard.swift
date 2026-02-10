import SwiftUI

struct FoodCard: View {
    let title: String
    let subtitle: String
    let price: String
    let imageURL: String
    let ratingText: String
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.black.opacity(0.06))
                }
                .frame(height: 160)
                .clipped()

                HStack(spacing: 8) {
                    Text("★ \(ratingText)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.55))
                        .clipShape(Capsule())

                    Spacer()

                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(isFavorite ? UITheme.primary : .white)
                            .padding(10)
                            .background(Color.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(UITheme.textMain)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            HStack {
                Text(price)
                    .font(.headline.weight(.bold))
                Spacer()
                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(UITheme.primary)
                        .clipShape(Circle())
                        .shadow(color: UITheme.shadow, radius: 10, y: 8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(UITheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: UITheme.shadow, radius: 18, y: 10)
    }
}
