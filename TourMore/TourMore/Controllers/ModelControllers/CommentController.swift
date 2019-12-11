//
//  CommentController.swift
//  TourMore
//
//  Created by Josh Sparks on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class CommentController {
    
    static let shared = CommentController()
    
    var ref: DatabaseReference?
    var firestoreDB = Firestore.firestore().collection("Comments")
    
    func addComment(text: String, rating: Double, businessID: String, completion: @escaping (Comment?, Error?) -> Void) {
        // save the comment to firebase
        guard let userID = UserController.shared.currentUser?.uid else {return}
        let commentID = UUID().uuidString
        let newComment = Comment(text: text, rating: rating, businessID: businessID, userID: userID, id: commentID)
        let ref = firestoreDB.document(newComment.id)
        ref.setData(newComment.dictionary) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil, error); return
            }
//            self.comments.append(newComment)
            UserController.shared.currentUser?.createdComments.append(newComment)
            UserController.shared.currentUser?.comment.append(newComment.id)
            completion(newComment, nil)
        }
    }
    
    func fetchCommentsForLocation(business: String, completion: @escaping([Comment]?) -> Void) {
        firestoreDB.whereField(CommentStringKeys.businessID, isEqualTo: business).getDocuments { (snapshot, error) in
            guard let foundData = snapshot?.documents else {completion(nil) ; return}
            let comments = foundData.compactMap({ Comment(dictionary: $0.data()) })
            completion(comments)
        }
    }
} // end of class
