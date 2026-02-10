import SwiftUI

struct PromoBanner: View {
    let titleTop: String
    let title: String
    let buttonTitle: String
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [Color(hex: "#FFE9D7"), Color(hex: "#FFF3E9")],
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 18, y: 10)

            VStack(alignment: .leading, spacing: 8) {
                Text(titleTop.uppercased())
                    .font(.caption2).fontWeight(.bold)
                    .foregroundStyle(UITheme.primary)
                    .tracking(1)

                Text(title)
                    .font(.title2).fontWeight(.black)
                    .foregroundStyle(UITheme.textMain)
                    .multilineTextAlignment(.leading)

                Button(buttonTitle, action: onTap)
                    .font(.caption).fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(UITheme.textMain)
                    .clipShape(Capsule())
                    .padding(.top, 2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)

            // “пузырь” как на дизайне
            Circle()
                .fill(UITheme.primary.opacity(0.18))
                .frame(width: 120, height: 120)
                .blur(radius: 18)
                .offset(x: 28, y: 34)

            // Можно заменить на AsyncImage с реальным URL
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(UITheme.primary.opacity(0.55))
                .rotationEffect(.degrees(-12))
                .offset(x: -6, y: -6)
        }
        .frame(height: 140)
    }
}
