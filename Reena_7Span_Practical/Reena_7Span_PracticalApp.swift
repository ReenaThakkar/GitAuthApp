//
//  Reena_7Span_PracticalApp.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/1/24.
//

import SwiftUI

@main
struct Reena_7Span_PracticalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
