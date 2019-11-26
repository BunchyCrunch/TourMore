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
    let timestamp: Date
    let commentUID: String
    
    init(text: String, timestamp: Date = Date(), commentUID: String) {
        self.text = text
        self.timestamp = timestamp
        self.commentUID = commentUID
    }
}
