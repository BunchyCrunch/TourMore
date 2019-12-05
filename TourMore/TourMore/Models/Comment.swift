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
    let commentUID: String
    
    init(text: String, rating: Int, businessID: String, uuid: String = UUID().uuidString) {
        self.text = text
        self.rating = rating
        self.businessID = businessID
        self.commentUID = uuid
    }
}
