import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = LoginViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.largeTitle.weight(.bold))

            TextField("Email", text: $vm.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .padding(12)
                .background(UITheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $vm.password)
                .textContentType(.password)
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
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(UITheme.primary)
            .disabled(vm.isLoading)

            NavigationLink("Create account") {
                RegisterView()
            }
            .padding(.top, 4)

            Spacer()
        }
        .padding()
        .background(UITheme.bg)
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(SessionViewModel())
    }
}
