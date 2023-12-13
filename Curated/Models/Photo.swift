//
//  Photo.swift
//  Curated
//
//  Created by Dom Parsons on 20/12/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Photo {
    @Attribute(.externalStorage) var photoData: Data?
    var creationDate: Date?
    var tags: [Tag]?
    
    init(photoData: Data? = nil, creationDate: Date? = nil, tags: [Tag]? = nil) {
        self.photoData = photoData
        self.creationDate = creationDate
        self.tags = tags
    }
    
    func formattedCreationDate() -> String? {
        guard let creationDate = creationDate else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium  // You can customize the date style as needed
        dateFormatter.timeStyle = .none   // Set time style to none to show only the date

        return dateFormatter.string(from: creationDate)
    }
}
