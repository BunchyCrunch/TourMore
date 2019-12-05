//
//  CommentController.swift
//  TourMore
//
//  Created by Josh Sparks on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentController {
    
    static let shared = CommentController()
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var comments: [Comment] = []
    
    func addComment(to location: String, text: String, rating: Int, completion: @escaping (Bool) -> Void) {
        // save the comment to firebase
        ref = Database.database().reference()
        let newComment = Comment(text: text, rating: rating, businessID: location)
        ref?.child("Comment").child(newComment.commentUID).setValuesForKeys(["text" : newComment.text, "rating" : newComment.rating, "businessID" : newComment.businessID])
        // add the comment to the comments array
        comments.append(newComment)
    }
    
    func fetchComment(for businessID: String, completion: @escaping(_ success: Bool) -> Void) {
        ref = Database.database().reference()
        ref?.child("Comment").queryEqual(toValue: businessID, childKey: "businessID")
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String : Any] {
             
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
} // end of class
