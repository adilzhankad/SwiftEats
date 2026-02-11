import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = ProfileViewModel()

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
                } else if let user = vm.user {
                    List {
                        Section("Profile") {
                            row(title: "Name", value: user.name)
                            row(title: "Email", value: user.email)
                            row(title: "ID", value: user.id)
                        }

                        Section {
                            Button(role: .destructive) {
                                session.logout()
                            } label: {
                                Text("Logout")
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Profile")
        }
        .task { await vm.load() }
    }

    private func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionViewModel())
}
