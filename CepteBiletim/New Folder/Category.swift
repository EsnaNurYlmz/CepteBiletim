//
//  Category.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import Foundation

class Category : Codable {
    
    var categoryID : String?
    var categoryName : String?
    var categoryImage : String?
    
    init(){
    }
    
    init(categoryID: String, categoryName: String, categoryImage : String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryImage = categoryImage
    }
    
}
