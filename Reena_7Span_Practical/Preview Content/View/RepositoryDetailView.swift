//
//  RepositoryDetailView.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/2/24.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name).font(.largeTitle)
            Text(repository.descriptionText ?? "No description").font(.subheadline)
            HStack {
                Text("Stars: \(repository.stargazers_count)")
                Text("Forks: \(repository.forks_count)")
            }
            Text("Last Updated: \(repository.updated_at)").font(.caption)
        }
        .padding()
    }
}
