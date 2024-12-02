//
//  Reena_7Span_PracticalApp.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/1/24.
//

import SwiftUI


@main
struct Reena_7Span_PracticalApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // Check if the user is authenticated to show either LoginView or RepositoryListView
            if authViewModel.isAuthenticated {
                RepositoryListView(accessToken: authViewModel.accessToken ?? "")
                    .environmentObject(authViewModel)
                    .onOpenURL { url in
                        authViewModel.handleIncomingURL(url)
                    }
                    .environment(\.managedObjectContext, persistenceController.context)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    .onOpenURL { url in
                        authViewModel.handleIncomingURL(url)
                    }
            }
        }
    }
}

