//
//  Comment.swift
//  TourMore
//
//  Created by Josh Sparks on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation

class Comment {
    let text: String
    let rating: Int
    let businessID: String
    let userID: String
    let id: String
    
    init(text: String, rating: Int, businessID: String, userID: String, id: String = UUID().uuidString) {
        self.text = text
        self.rating = rating
        self.businessID = businessID
        self.userID = userID
        self.id = id
    }
}
