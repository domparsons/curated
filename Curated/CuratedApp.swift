//
//  CuratedApp.swift
//  Curated
//
//  Created by Dom Parsons on 13/12/2023.
//

import SwiftUI
import SwiftData

@main
struct CuratedApp: App {
    
    let photoModelContainer: ModelContainer
    let tagModelContainer: ModelContainer
    
    init() {
        do {
            photoModelContainer = try ModelContainer(for: Photo.self)
            tagModelContainer = try ModelContainer(for: Tag.self)
        } catch {
            fatalError("Could not initialise ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Photo.self, Tag.self])
        }
    }
}
