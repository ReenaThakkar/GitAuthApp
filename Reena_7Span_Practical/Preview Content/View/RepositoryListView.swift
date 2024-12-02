//
//  RepositoryListView.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/1/24.
//

import SwiftUI

import SwiftUI

struct RepositoryListView: View {
    var accessToken: String
    @StateObject private var viewModel = RepositoryViewModel()

    var body: some View {
        Button("Remove Auth Token and relaunch application") {
            AuthViewModel.clearAuthData()
        }
        .padding()
        
        NavigationView {
            List(viewModel.repositories) { repo in
                NavigationLink(destination: RepositoryDetailView(repository: viewModel.repositories[0])) {
                    Text(repo.name)
                }
            }
            .onAppear {
                viewModel.fetchRepositories(accessToken: accessToken)
            }
            .navigationTitle("Repositories")
        }
    }
}
