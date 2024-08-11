//
//  ContentView.swift
//  Curated
//
//  Created by Dom Parsons on 13/12/2023.
//

import SwiftUI
import SwiftData
import PhotosUI
import CoreHaptics

struct ContentView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Photo.creationDate, order: .reverse) var photos: [Photo]
    @Query(sort: \Tag.name) var tags: [Tag] 
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State private var arrangement = UserDefaults.standard.string(forKey: "photoDisplayView")
    @State private var engine: CHHapticEngine?
    
    @State var selectedTags: [Tag] = []
    @State var showingTagsSheet = false
    @State var uploadingPhotos = false
    @State var selectedForImport: [PhotosPickerItem] = []
    @State var selectionModeEnabled: Bool = false
    @State var selectedPhotos: [Photo] = []
    @State var showingDeleteConfirmation = false
    @State var showingUpgradeView = false
    @State var imagesToBeShared: [UIImage] = []
    @State var isShareSheetPresented = false
    
    var maximumFreePhotos: Int = 100
    
    var searchResults: [Photo] {
        if searchText.isEmpty {
            return photos
        } else {
            if searchText.lowercased() == "none" {
                return photos.filter { photo in
                    photo.tags?.isEmpty == true
                }
            }
            return photos.filter { photo in
                photo.tags?.contains { tag in
                    tag.name?.localizedCaseInsensitiveContains(searchText) == true
                } == true
            }
        }
    }

    let images = (1...20).map { Image("image\($0)") }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        if UserDefaults.standard.string(forKey: "photoDisplayView") == "standard" {
                            StandardView(searchResults: searchResults, selectionModeEnabled: $selectionModeEnabled, selectedPhotos: $selectedPhotos)
                        } else if UserDefaults.standard.string(forKey: "photoDisplayView") == "grid" {
                            GridView(searchResults: searchResults, selectionModeEnabled: $selectionModeEnabled, selectedPhotos: $selectedPhotos)
                        }
                    }
                    .toolbar() {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Curated")
                                .font(.body.bold())
                        }
                        
                        ToolbarItem {
                            Spacer()
                        }
                        
                        if !selectionModeEnabled {
                            ToolbarItem {
                                PhotosPicker(selection: $selectedForImport, matching: .images) {
                                    Image(systemName: "photo.badge.plus")
                                }
                                .buttonStyle(.borderless)
                                .onChange(of: selectedForImport) {
                                    if selectedForImport != [] {
                                        if validateMembership() {
                                            showingTagsSheet = true
                                        } else {
                                            showingUpgradeView = true
                                        }
                                    }
                                }
                            }
                            ToolbarItem {
                                Button {
                                    updatePhotoDisplayView()
                                } label: {
                                    Image(systemName: arrangement == "grid" ? "square.grid.2x2" : "rectangle.grid.1x2")
                                }
                            }
                        }
                        ToolbarItem {
                            Button {
                                selectedPhotos = []
                                selectionModeEnabled.toggle()
                            } label: {
                                if selectionModeEnabled {
                                    Text("Done")
                                } else {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                        }
                    }
                }
                if selectionModeEnabled {
                    SelectionOverlayView(selectedPhotos: $selectedPhotos, showingDeleteConfirmation: $showingDeleteConfirmation, imagesToBeShared: $imagesToBeShared, isShareSheetPresented: $isShareSheetPresented, showingTagsSheet: $showingTagsSheet)
                }
            }
            .onAppear {
                getSavedArrangement()
            }
            .confirmationDialog("Delete \(selectedPhotos.count) photos?", isPresented: $showingDeleteConfirmation) {
                Button(selectedPhotos.count == 1 ? "Delete photo" : "Delete photos", role: .destructive) {
                    deleteSelectedPhotos()
                }
                Button("Cancel", role: .cancel) { }
            }
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search tags")
            .sheet(isPresented: $showingTagsSheet) {
                ImportTagsView(tags: tags, selectedTags: $selectedTags, showingTagsSheet: $showingTagsSheet, uploadingPhotos: $uploadingPhotos, selectedForImport: $selectedForImport)
            }
            .sheet(isPresented: $showingUpgradeView) {
                UpgradeAccountView()
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: imagesToBeShared, applicationActivities: nil)
            }
        }
        .onAppear() {
            curatedDidLoad()
        }
    }
    
    func validateMembership() -> Bool {
        // Add if is member
        if ((photos.count + selectedForImport.count) > maximumFreePhotos) {
            return false
        }
        return true
    }
    
    func curatedDidLoad() {
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        
        if UserDefaults.standard.integer(forKey: "launchCount") == 1 {
            UserDefaults.standard.set("standard", forKey:"photoDisplayView")
        }
    }
    
    func updatePhotoDisplayView() {
        if arrangement == "grid" {
            UserDefaults.standard.setValue("standard", forKey: "photoDisplayView")
            arrangement = "standard"
        } else {
            UserDefaults.standard.setValue("grid", forKey: "photoDisplayView")
            arrangement = "grid"
        }
    }

    func deleteSelectedPhotos() {
        for photo in selectedPhotos {
            context.delete(photo)
        }
        selectionModeEnabled = false
    }
    
    func getSavedArrangement() {
        arrangement = UserDefaults.standard.string(forKey: "photoDisplayView")
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Tag.self, Photo.self], inMemory: true)
}
