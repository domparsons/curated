//
//  PhotoDetailView.swift
//  Curated
//
//  Created by Dom Parsons on 12/01/2024.
//

import SwiftUI
import SwiftData

struct PhotoDetailView: View {
    var photo: Photo
    var photoData: Data
    var uiImage: UIImage
    
    @State private var isShareSheetPresented = false
    
    @State var showingAddTagAlert = false

    @State private var sheetHeight: CGFloat = .zero
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(0)
                
                HStack(alignment: .center, spacing: 20) {
                    HStack {
                        if let tags = photo.tags {
                            let sortedTags = tags.sorted { $0.name ?? "" < $1.name ?? "" }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Button {
                                        context.delete(photo)
                                    } label: {
                                        HStack {
                                            Image(systemName: "trash")
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(1)
                                    
                                    Button(action: {
                                        isShareSheetPresented.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                            Text("Share")
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(1)
                                    .sheet(isPresented: $isShareSheetPresented) {
                                        ShareSheet(activityItems: [uiImage], applicationActivities: nil)
                                    }
                                    
                                    Button {
                                        showingAddTagAlert = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "tag")
                                            Text("Tags")
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(1)
                                    
                                    ForEach(sortedTags) { tag in
                                        Text(tag.name!)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.secondary, lineWidth: 1)
                                            )
                                            .padding(1)
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showingAddTagAlert) {
                AddTagsView(photo: photo)
            }
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight), .large])
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//#Preview {
//    PhotoDetailView()
//}
