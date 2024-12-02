import Foundation
import KeychainAccess
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var accessToken: String? {
        didSet {
            //store it in the Keychain
            if let token = accessToken {
                KeychainManager.saveToken(token)  // Save to Keychain
            } else {
                KeychainManager.removeToken()  // Remove from Keychain
            }
        }
    }
    
    // Singleton Keychain Manager
    static let keychain = Keychain(service: Constant.keyChainKey)
    
    // Static reference to the AuthViewModel
    static var authViewModel: AuthViewModel?
    
    // Initialize with existing token if available
    init() {
        if let savedToken = KeychainManager.getToken() {
            self.accessToken = savedToken
            self.isAuthenticated = true
        }
    }

    // Handle the incoming URL after authentication
    func handleIncomingURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            errorMessage = "Invalid URL"
            return
        }

        if let code = queryItems.first(where: { $0.name == "code" })?.value {
            // Use the authorization code to exchange for an access token
            fetchAccessToken(using: code)
        } else if let error = queryItems.first(where: { $0.name == "error" })?.value {
            errorMessage = "Authentication error: \(error)"
        }
    }

    // Fetch access token from server using the authorization code
    private func fetchAccessToken(using code: String) {
        let tokenURL = URL(string: Constant.authUrl)!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "client_id": Constant.clientID, // Your client ID
            "client_secret": Constant.clientSecret,// Your client secret
            "code": code,
            "redirect_uri": Constant.redirectURI
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "No response from server"
                }
                return
            }

            if httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.errorMessage = "HTTP Error: \(httpResponse.statusCode)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                }
                return
            }

            do {
                if let tokenResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let accessToken = tokenResponse["access_token"] as? String {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.accessToken = accessToken
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid response from server: \(String(data: data, encoding: .utf8) ?? "No response")"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "JSON decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // Function to clear authentication data
    static func clearAuthData() {
        // Remove token from Keychain
        KeychainManager.removeToken()
        authViewModel?.isAuthenticated = false
        authViewModel?.accessToken = nil
       
    }
}

// Keychain Manager for easier Keychain interaction
class KeychainManager {
    private static let keychain = Keychain(service: Constant.keyChainKey)

    // Save token to Keychain
    static func saveToken(_ token: String) {
        do {
            try keychain.set(token, key: "accessToken")
        } catch {
            print("Error saving token to Keychain: \(error)")
        }
    }

    // Retrieve token from Keychain
    static func getToken() -> String? {
        do {
            return try keychain.get("accessToken")
        } catch {
            print("Error retrieving token from Keychain: \(error)")
            return nil
        }
    }

    // Remove token from Keychain
    static func removeToken() {
        do {
            try keychain.remove("accessToken")
        } catch {
            print("Error removing token from Keychain: \(error)")
        }
    }
}
