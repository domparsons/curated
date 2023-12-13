////
////  Folder.swift
////  Curated
////
////  Created by Dom Parsons on 20/12/2023.
////
//
//import Foundation
//import SwiftData
//
//@Model
//class Folder {
//
//    var name: String = "Unknown name"
//    var creationDate: Date?
//    var keyPhoto: Photo?
//    var folderSortOption: FolderSortOption?
//    
//    enum FolderSortOption: Codable {
//        case newestFirst
//        case oldestFirst
//        case random
//    }
//    
//    init(name: String, creationDate: Date? = nil, keyPhoto: Photo? = nil, folderSortOption: FolderSortOption? = nil) {
//        self.name = name
//        self.creationDate = creationDate
//        self.keyPhoto = keyPhoto
//        self.folderSortOption = folderSortOption
//    }
//}
