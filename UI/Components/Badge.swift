//
//  Badge.swift
//  SwiftEats
//
//  Created by Adilzhan Kadyrov on 08.02.2026.
//

import SwiftUI

struct Badge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .foregroundStyle(UITheme.primaryDarker)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(UITheme.primary.opacity(0.14))
            .clipShape(Capsule())
    }
}

#Preview {
    Badge(text: "Preparing")
}
