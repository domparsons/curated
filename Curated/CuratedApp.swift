//
//  CuratedApp.swift
//  Curated
//
//  Created by Dom Parsons on 13/12/2023.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct CuratedApp: App {
    
    @Environment(\.modelContext) private var context
    
    let photoModelContainer: ModelContainer
    let tagModelContainer: ModelContainer
    
    init() {
        do {
            photoModelContainer = try ModelContainer(for: Photo.self)
            tagModelContainer = try ModelContainer(for: Tag.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Photo.self, Tag.self])
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)])
                }
        }
    }
}
