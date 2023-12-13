//
//  ImportTagsView.swift
//  Curated
//
//  Created by Dom Parsons on 03/02/2024.
//

import SwiftUI
import PhotosUI
import TipKit
import SwiftData

struct ImportTagsView: View {
    
    @Environment(\.modelContext) var context
    
    var tags: [Tag]
    
    let addTagTip = AddTagTip()
    
    @State var showingAddTagAlert = false
    @State var tagName = ""
    
    @Binding var selectedTags: [Tag]
    @Binding var showingTagsSheet: Bool
    @Binding var uploadingPhotos: Bool
    @Binding var selectedForImport: [PhotosPickerItem]
    
    var body: some View {

        NavigationStack {
            VStack {
                if tags != [] {
                    List {
                        ForEach(tags) { tag in
                            HStack {
                                Text(tag.name!)
                                Spacer()
                                if selectedTags.contains(tag) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedTags.contains(tag) {
                                    self.selectedTags.removeAll { $0 == tag }
                                } else {
                                    selectedTags.append(tag)
                                }
                            }
                        }
                    }
                } else {
                    Spacer()
                    VStack {
                        Button("Add first tag") {
                            showingAddTagAlert = true
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingAddTagAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popoverTip(addTagTip)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        showingTagsSheet = false
                        newPhotos()
                    }
                }
            }
            .alert("Add tag", isPresented: $showingAddTagAlert) {
                TextField("Add tag", text: $tagName)
                Button("Add") {
                    let newTag = Tag(name: tagName, photos: [])
                    self.context.insert(newTag)
                    tagName = ""
                }
            } message: {
                Text("Add tag")
            }
        }
    }
    
    func newPhotos() {
        Task {
            uploadingPhotos = true
            for photo in selectedForImport {
                do {
                    let data = try await photo.loadTransferable(type: Data.self)
                    // Check if the file size is less than 5MB (5 * 1024 * 1024 bytes)
                    let fileSizeInMB = Double(data?.count ?? 0) / (1024 * 1024)
                    guard fileSizeInMB < 5 else {
                        print("File size is greater than 5MB. Skipping.")
                        continue
                    }
                    let newPhoto = Photo(photoData: data, creationDate: Date.now, tags: selectedTags)
                    self.context.insert(newPhoto)
                    if self.context.hasChanges {
                        do {
                            try self.context.save()
                        } catch {
                            print("Error saving photo")
                        }
                    }
                } catch {
                    print("Error loading photo data")
                }
            }
            selectedForImport = []
            selectedTags = []
            uploadingPhotos = false
        }
    }
}

//#Preview {
//    ImportTagsView()
//}
