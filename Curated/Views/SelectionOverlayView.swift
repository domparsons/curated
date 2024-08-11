//
//  SelectionOverlayView.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import SwiftUI
import SwiftData

struct Placeholder: View {
    var body: some View {
        Color.gray
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SelectionOverlayView: View {
    
    @Binding var selectedPhotos: [Photo]
    @Binding var showingDeleteConfirmation: Bool
    @Binding var imagesToBeShared: [UIImage]
    @Binding var isShareSheetPresented: Bool
    @Binding var showingTagsSheet: Bool
    
    @State var showingSelectionSettings: Bool = false
    @State var previewScale = 1.0
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if showingSelectionSettings {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingSelectionSettings = false
                            previewScale = 1
                        }
                    }
            }
            
            GeometryReader { geo in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                if !showingSelectionSettings {
                                    VStack {
                                        Text("\(selectedPhotos.count)")
                                            .font(.title)
                                        Text("selected")
                                            .font(.caption)
                                    }
                                    
                                    // Display a preview of the most recently selected images
                                    if !selectedPhotos.isEmpty {
                                        RecentImagesPreview(selectedPhotos: selectedPhotos, largePreview: false)
                                            .matchedGeometryEffect(id: "imagePreview", in: namespace)
                                            .animation(.bouncy, value: showingSelectionSettings)
                                            .scaleEffect(previewScale)
                                            .animation(.linear(duration: 1), value: previewScale)
                                            .padding(.horizontal, 15)
                                    } else {
                                        Placeholder()
                                            .padding(.horizontal, 15)
                                    }
                                }
                                
                                if showingSelectionSettings {
                                    Button {
                                        showingDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .font(.title3)
                                }
                                
                                Button {
                                    showingSelectionSettings ? showingTagsSheet = true : withAnimation {showingSelectionSettings.toggle() }
                                    previewScale = 4
                                } label: {
                                    showingSelectionSettings ? Image(systemName: "tag") : Image(systemName: "ellipsis")
                                }
                                .font(.title3)
                                .padding(showingSelectionSettings ? 10 : 20)
                                .foregroundStyle(.white)
                                .background(.tint)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .animation(.bouncy, value: showingSelectionSettings)
                                .padding(.horizontal, showingSelectionSettings ? 10 : 0)
                                
                                if showingSelectionSettings {
                                    Button {
                                        shareSelectedPhotos()
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    .font(.title3)
                                }
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.trailing, 15)
                        .padding(.leading, 25)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .padding(.bottom, 30)
                        
                        Spacer()
                    }
                }
            }
            
            if showingSelectionSettings {
                RecentImagesPreview(selectedPhotos: selectedPhotos, largePreview: true)
                    .matchedGeometryEffect(id: "imagePreview", in: namespace)
                    .animation(.bouncy, value: showingSelectionSettings)
                    .scaleEffect(previewScale)
                    .animation(.bouncy, value: previewScale)
                    .padding(.bottom, 50)
            }
        }
    }
    
    func shareSelectedPhotos() {
        imagesToBeShared.removeAll()
        
        for photo in selectedPhotos {
            let photoData = photo.photoData!
            if let imageToBeShared = UIImage(data: photoData) {
                imagesToBeShared.append(imageToBeShared)
            }
        }
        showShareSheet()
    }
    
    func showShareSheet() {
        isShareSheetPresented = true
    }
}

struct RecentImagesPreview: View {
    var selectedPhotos: [Photo]
    var largePreview: Bool
    
    
    
    var body: some View {
        ZStack {
            ForEach(selectedPhotos.indices, id: \.self) { index in
                Group {
                    if let photoData = selectedPhotos[index].photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .rotationEffect(.degrees(calculateRotation(index: index, numPhotos: selectedPhotos.count)))
                            .offset(x: CGFloat(calculateOffset(index: index, numPhotos: selectedPhotos.count)))
                    } else {
                        Placeholder()
                    }
                }
            }
        }
    }
    
    func calculateOffset(index: Int, numPhotos: Int) -> Double {
        if numPhotos == 1 {
            return 0
        } else if numPhotos == 2 {
            return index == (numPhotos - 1) ? 10 : 0
        } else {
            return index == (numPhotos - 3) ? -10 : (index == (numPhotos - 2) ? 0 : 10)
        }
    }
    
    func calculateRotation(index: Int, numPhotos: Int) -> Double {
        if numPhotos == 1 {
            return 0
        } else if numPhotos == 2 {
            return index == (numPhotos - 1) ? 30 : -30
        } else {
            return index == (numPhotos - 3) ? -30 : (index == (numPhotos - 2) ? 0 : 30)
        }
    }
}


#Preview {
    ZStack {
        SelectionOverlayView(
            selectedPhotos: .constant([
                Photo(photoData: UIImage(named: "preview1")?.pngData() ?? Data()),
                Photo(photoData: UIImage(named: "preview2")?.pngData() ?? Data()),
                Photo(photoData: UIImage(named: "preview3")?.pngData() ?? Data()),
                Photo(photoData: UIImage(named: "preview4")?.pngData() ?? Data()),
                Photo(photoData: UIImage(named: "preview5")?.pngData() ?? Data())
            ]),
            showingDeleteConfirmation: .constant(false),
            imagesToBeShared: .constant([]),
            isShareSheetPresented: .constant(false),
            showingTagsSheet: .constant(false))
    }
}
