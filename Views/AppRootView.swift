import SwiftUI

struct AppRootView: View {
    @StateObject private var session = SessionViewModel()

    var body: some View {
        Group {
            switch session.state {
            case .checking:
                ProgressView()
                    .task { await session.refreshMe() }

            case .unauthenticated:
                NavigationStack {
                    LoginView()
                }
                .environmentObject(session)

            case .authenticated:
                RootTabView()
                    .environmentObject(session)
                    .task { await session.refreshMe() }
            }
        }
    }
}

#Preview {
    AppRootView()
}
