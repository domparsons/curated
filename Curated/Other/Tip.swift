//
//  Tip.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import Foundation
import TipKit

struct AddTagTip: Tip {
    var title: Text  {
        Text("Add New Tip")
    }
    
    var message: Text? {
        Text("Tap here to add a new tag")
    }
    
    var image: Image? {
        Image(systemName: "tag")
    }
}
