//
//  TODO_CategoryApp.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//

import SwiftUI

@main
struct TODO_CategoryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
