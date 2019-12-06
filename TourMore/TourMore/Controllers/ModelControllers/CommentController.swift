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
    
    var comments: [Comment] = [Comment(text: "lehi", rating: 3, businessID: "asdfljasl", userID: "dlafjds"),
                               Comment(text: "provo", rating: 5, businessID: "aldsfkjas", userID: "sldfjk")]
    
    func addComment(to location: String, text: String, rating: Int, userID: String, completion: @escaping (Bool) -> Void) {
        // save the comment to firebase
        ref = Database.database().reference()
        let newComment = Comment(text: text, rating: rating, businessID: location, userID: userID)
        ref?.child("Comment").child(newComment.id).setValuesForKeys(["text" : newComment.text, "rating" : newComment.rating, "businessID" : newComment.businessID])
        // add the comment to the comments array
        comments.append(newComment)
    }
    
    func fetchComment(for businessID: String, completion: @escaping(_ success: Bool) -> Void) {
        ref = Database.database().reference()
        ref?.child("Comment").queryEqual(toValue: businessID, childKey: "businessID")
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? [String : Any]
            print(data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
} // end of class
