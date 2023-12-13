//
//  SinglePhotoView.swift
//  Curated
//
//  Created by Dom Parsons on 12/01/2024.
//

import SwiftUI

struct SinglePhotoView: View {
    
    @Environment(\.modelContext) var context
    var photo: Photo
    var photoData: Data
    var uiImage: UIImage
    
    @State var showingPhotoDetailView = false
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .padding(0)
            .onTapGesture {
                showingPhotoDetailView = true
            }
            .sheet(isPresented: $showingPhotoDetailView) {
                PhotoDetailView(photo: photo, photoData: photoData, uiImage: uiImage)
            }
            .contextMenu {
                Button {
                    showingPhotoDetailView = true
                } label: {
                    Label("Fullscreen", systemImage: "square.arrowtriangle.4.outward")
                }
                Button {
                    context.delete(photo)
                } label: {
                    Label("Permanently delete", systemImage: "trash")
                }
            }
    }
}

//#Preview {
//    SinglePhotoView(photo: <#Photo#>, photoData: <#Data#>, uiImage: <#UIImage#>)
//        .modelContainer(for: [Tag.self, Photo.self], inMemory: true)
//}
