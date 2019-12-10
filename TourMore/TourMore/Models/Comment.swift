//
//  Comment.swift
//  TourMore
//
//  Created by Josh Sparks on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation

struct CommentStringKeys {
    static let text = "text"
    static let rating = "rating"
    static let businessID = "businessID"
    static let userID = "userID"
    static let id = "id"
}

class Comment {
    let text: String
    let rating: Double
    let businessID: String
    let userID: String
    let id: String
    
    init(text: String, rating: Double, businessID: String, userID: String, id: String = UUID().uuidString) {
        self.text = text
        self.rating = rating
        self.businessID = businessID
        self.userID = userID
        self.id = id
    }
    
    var dictionary: [String: Any] {
        return [CommentStringKeys.text : text,
                CommentStringKeys.rating : rating,
                CommentStringKeys.businessID : businessID,
                CommentStringKeys.userID : userID,
                CommentStringKeys.id : id
        ]
    }
}

extension Comment {
    convenience init?(dictionary: [String : Any] ) {
        guard let text = dictionary[CommentStringKeys.text] as? String,
            let rating = dictionary[CommentStringKeys.rating] as? Double,
            let businessID = dictionary[CommentStringKeys.businessID] as? String,
            let userID = dictionary[CommentStringKeys.userID] as? String,
            let id = dictionary[CommentStringKeys.id] as? String
            else {return nil}
        
        self.init(text: text, rating: rating, businessID: businessID, userID: userID, id: id)
    }
}
