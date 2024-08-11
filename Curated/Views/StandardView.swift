//
//  StandardView.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import SwiftUI

struct StandardView: View {
    
    var searchResults: [Photo]
    
    @Binding var selectionModeEnabled: Bool
    @Binding var selectedPhotos: [Photo]
    
    var body: some View {
        ForEach(searchResults) { photo in
            if let photoData = photo.photoData,
               let uiImage = UIImage(data: photoData) {
                if !selectionModeEnabled {
                    SinglePhotoView(photo: photo, photoData: photoData, uiImage: uiImage)
                        .padding(.bottom, 10)
                        
                } else {
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .padding(0)
                            .padding(.bottom, 10)
                        
                        VStack {
                            HStack {
                                Spacer()
                                
                                Group {
                                    if !selectedPhotos.contains(photo) {
                                        Image(systemName: "circle")
                                            .padding()
                                    } else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .padding()
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
                            withAnimation {
                                selectedPhotos.append(photo)
                            }
                        }
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedPhotos)
    }
}

//#Preview {
//    StandardView()
//}
