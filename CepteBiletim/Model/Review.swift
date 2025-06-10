//
//  Review.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import Foundation
class Review : Codable {
    
    var reviewID: String?
    var eventID : String?
    var userID : String?
    var review : String?
    var reviewPoint : String?
    
    init(){
    }
    
    init(reviewID: String, eventID: String, userID: String, review: String, reviewPoint: String) {
        self.reviewID = reviewID
        self.eventID = eventID
        self.userID = userID
        self.review = review
        self.reviewPoint = reviewPoint
    }
}
