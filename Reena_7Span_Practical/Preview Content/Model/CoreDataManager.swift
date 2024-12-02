//
//  CoreDataManager.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/2/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GitHubModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveRepositories(_ repositories: [Repository]) {
        let context = container.viewContext
        repositories.forEach { repo in
            let repository = RepositoryEntity(context: context)
            repository.id = Int64(repo.id)
            repository.name = repo.name
            repository.descriptionText = repo.descriptionText
            repository.stars = Int64(repo.stargazers_count)
            repository.forks = Int64(repo.forks_count)
            repository.lastUpdated = repo.updated_at
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save repositories: \(error.localizedDescription)")
        }
    }
    
    // Fetch repositories from Core Data
    func fetchRepositories() -> [Repository] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        
        do {
            let repositoryEntities = try context.fetch(fetchRequest)
            return repositoryEntities.map {
                Repository(
                    id: Int($0.id),
                    name: $0.name ?? "",
                    descriptionText: $0.descriptionText,
                    stargazers_count: Int($0.stars),
                    forks_count: Int($0.forks),
                    updated_at: $0.lastUpdated ?? Date()
                )
            }
        } catch {
            print("Failed to fetch repositories: \(error.localizedDescription)")
            return []
        }
    }
    
    // Check if a repository already exists
    private func repositoryExists(id: Int64) -> Bool {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check existence of repository: \(error.localizedDescription)")
            return false
        }
    }
    
}
