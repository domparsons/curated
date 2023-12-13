//
//  SelectionOverlayView.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import SwiftUI

struct SelectionOverlayView: View {
    
    @Binding var selectedPhotos: [Photo]
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(selectedPhotos.count == 1 ? "\(selectedPhotos.count) photo selected" : "\(selectedPhotos.count) photos selected")
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, 30)
        }
    }
}

//#Preview {
//    SelectionOverlayView()
//}
