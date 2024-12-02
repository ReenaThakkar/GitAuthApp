import Foundation

class GitHubAPIService {
    static let shared = GitHubAPIService()

    func fetchRepositories(accessToken: String, page: Int, completion: @escaping ([Repository]?, Error?) -> Void) {
        let url = URL(string: "https://api.github.com/user/repos?per_page=30&page=\(page)")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                }
                return
            }

            // Debug: Print raw JSON
            print("Raw JSON Response: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repositories = try decoder.decode([Repository].self, from: data)
                DispatchQueue.main.async {
                    completion(repositories, nil)
                }
            } catch {
                print("Decoding Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
