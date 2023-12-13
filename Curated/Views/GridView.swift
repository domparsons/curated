//
//  GridView.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import SwiftUI
import CoreHaptics

struct GridView: View {
    var searchResults: [Photo]
    
    @Binding var selectionModeEnabled: Bool
    @Binding var selectedPhotos: [Photo]
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
            ForEach(searchResults) { photo in
                if let photoData = photo.photoData,
                   let uiImage = UIImage(data: photoData) {
                    if !selectionModeEnabled {
                        SinglePhotoView(photo: photo, photoData: photoData, uiImage: uiImage)
                            .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 15)
                            .aspectRatio(contentMode: .fill)
                            .contentShape(Rectangle())
                            .clipped()
                    } else {
                        ZStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .padding(0)
                                .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 15)
                                .aspectRatio(contentMode: .fill)
                                .contentShape(Rectangle())
                                .clipped()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Group {
                                        if !selectedPhotos.contains(photo) {
                                            Image(systemName: "circle")
                                                .padding(10)
                                        } else {
                                            Image(systemName: "checkmark.circle.fill")
                                                .padding(10)
                                        }
                                    }
                                    .font(.title3)
                                    .opacity(0.5)
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 100))
                                    .padding(10)
                                }
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            if selectedPhotos.contains(photo), let index = selectedPhotos.firstIndex(of: photo) {
                                selectedPhotos.remove(at: index)
                            } else {
                                selectedPhotos.append(photo)
                            }
                        }
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: selectedPhotos)
        }
        .padding(10)
    }
}

//#Preview {
//    GridView()
//}
