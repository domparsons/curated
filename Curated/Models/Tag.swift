//
//  Tag.swift
//  Curated
//
//  Created by Dom Parsons on 12/01/2024.
//

import Foundation
import SwiftData

@Model
class Tag {
    var name: String?
    var photos: [Photo]?
    
    init(name: String? = nil, photos: [Photo]? = nil) {
        self.name = name
        self.photos = photos
    }
}
