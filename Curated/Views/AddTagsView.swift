//
//  AddTagsView.swift
//  Curated
//
//  Created by Dom Parsons on 13/01/2024.
//

import SwiftUI
import SwiftData

struct AddTagsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddTagAlert = false
    @State private var tagName = ""
    
    @Environment(\.modelContext) var context
    
    var photo: Photo
    
    @Query(sort: \Tag.name) var tags: [Tag]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tags) { tag in
                    HStack {
                        Text(tag.name!)
                        Spacer()
                        if let photoTags = photo.tags, photoTags.contains(tag) {
                            // Display checkmark if the tag is associated with the photo
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let photoTags = photo.tags, !photoTags.contains(tag) {
                            photo.tags?.append(tag)
                            tag.photos?.append(photo)
                        } else if let photoTags = photo.tags, let index = photoTags.firstIndex(of: tag) {
                            photo.tags?.remove(at: index)
                            tag.photos?.removeAll(where: { $0 == photo })
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(tags[index])
                    }
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
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
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
}

//#Preview {
//    let previewTag = Tag(name: "tagggg", photos: [])
//    let previewPhoto = Photo(photoData: nil, creationDate: nil, tags: [previewTag])
//    AddTagsView(photo: previewPhoto, tags: [previewTag])
//}
