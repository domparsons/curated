//
//  QuickLookPreview.swift
//  Curated
//
//  Created by Dom Parsons on 02/06/2024.
//

import Foundation
import SwiftUI
import QuickLook

// QuickLookPreview for QLPreviewController integration
struct QuickLookPreview: UIViewControllerRepresentable {
    var previewItem: QLPreviewItem

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: QuickLookPreview

        init(_ parent: QuickLookPreview) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.previewItem
        }
    }
}
