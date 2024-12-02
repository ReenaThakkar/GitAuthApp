//
//  RepositoryViewModel.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/1/24.
//

import Foundation

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    private var accessToken: String?
    private let coreDataManager = CoreDataManager.shared

    // Fetch repositories from GitHub and save to Core Data
    func fetchRepositories(accessToken: String) {
        self.accessToken = accessToken
        
        GitHubAPIService.shared.fetchRepositories(accessToken: accessToken, page: 1) { [weak self] repos, error in
            if let repos = repos {
                self?.repositories = repos
                CoreDataManager.shared.saveRepositories(repos) // Save to Core Data
            } else {
                // If online request fails, load from Core Data
                self?.loadOfflineRepositories()
            }
        }
    }

    // Load repositories from Core Data
    func loadOfflineRepositories() {
        let cachedRepos = self.coreDataManager.fetchRepositories()
        DispatchQueue.main.async {
            self.repositories = cachedRepos
        }
    }
}
