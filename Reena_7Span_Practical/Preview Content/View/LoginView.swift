import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = RepositoryViewModel()

    var body: some View {
        VStack {
            if authViewModel.isAuthenticated {
                Text("Welcome to the App!")
                    .padding()
                
                // Check if repositories are available, load offline if needed
                if viewModel.repositories.isEmpty {
                    Text("Loading Offline Repositories...")
                        .onAppear {
                            viewModel.loadOfflineRepositories()
                        }
                }

                // If repositories are still empty after attempting to load offline, fetch from GitHub
                if viewModel.repositories.isEmpty {
                    Text("Fetching Repositories...")
                        .onAppear {
                            if let accessToken = authViewModel.accessToken {
                                viewModel.fetchRepositories(accessToken: accessToken)
                            }
                        }
                } else {
                    RepositoryListView(accessToken: authViewModel.accessToken ?? "")
                        .navigationBarHidden(true)
                }
            } else {
                Button(action: {
                    let scope = "repo user"
                    let authURL = "https://github.com/login/oauth/authorize?client_id=\(Constant.clientID)&redirect_uri=\(Constant.redirectURI)&scope=\(scope)"
                    
                    if let url = URL(string: authURL) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Login with GitHub")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.horizontal)

                if let errorMessage = authViewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
    }
}
