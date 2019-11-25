//
//  UserController.swift
//  TourMore
//
//  Created by Christopher Alegre on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import Firebase

class UserController {
    
    static let shared = UserController()
    var currentUser: User?
    let firebaseDB = Firestore.firestore()
    
    
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let user = authResult else {return}
            let newUser = User(uid: user.user.uid)
            self.currentUser = newUser
            completion(true)
        }
    }
    
    func fetchUser(with email: String, password: String, completion: @escaping(_ successl: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let user = authResult else {return}
            let loggedInUser = User(uid: user.user.uid)
            self.currentUser = loggedInUser
            let ref = self.firebaseDB.collection("users").document(user.user.uid)
            ref.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                }
                let name = snapshot?.get("name") as! String
                self.currentUser?.name = name
                completion(true)
            }
        }
    }
    
    func signOutUser(user: User, completion: @escaping (_ success: Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            print("Error signing out: %@")
        }
        completion(true)
    }
    
    func updateUser(with name: String, completion: @escaping () -> Void) {
        
    }
}
