import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search", text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}
