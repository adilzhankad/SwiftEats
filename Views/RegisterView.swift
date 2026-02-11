import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = RegisterViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Register")
                .font(.largeTitle.weight(.bold))

            TextField("Name", text: $vm.name)
                .textInputAutocapitalization(.words)
                .textContentType(.name)
                .onChange(of: vm.name) { _, _ in
                    vm.errorMessage = nil
                }
                .padding(12)
                .background(UITheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            TextField("Email", text: $vm.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .onChange(of: vm.email) { _, _ in
                    vm.errorMessage = nil
                }
                .padding(12)
                .background(UITheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $vm.password)
                .textContentType(.newPassword)
                .onChange(of: vm.password) { _, _ in
                    vm.errorMessage = nil
                }
                .padding(12)
                .background(UITheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if let message = vm.errorMessage {
                Text(message)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task { await vm.submit(session: session) }
            } label: {
                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Create account")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(UITheme.primary)
            .disabled(vm.isLoading)

            Spacer()
        }
        .padding()
        .background(UITheme.bg)
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(SessionViewModel())
    }
}
