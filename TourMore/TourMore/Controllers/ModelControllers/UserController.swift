//
//  UserController.swift
//  TourMore
//
//  Created by Christopher Alegre on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserController {
    
    static let shared = UserController()
    var currentUser: User?
    let firebaseDB = Firestore.firestore()
    
    //MARK: CREATE USER
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
    
    func signInWithApple(credential: OAuthCredential, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard authResult != nil ,
                let uuid = credential.accessToken
                else { completion(false) ; return }
            
            let user = User(uid: uuid)
            self.currentUser = user
            completion(true)
        }
    }
    
    //MARK: FETCH FUNCTIONS
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
    
    func fetchProfilePicture(completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = currentUser else { return }
        let storageRef = Storage.storage().reference(withPath: "profilepictures/\(currentUser.uid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            if let data = data {
                let downloadedImage = UIImage(data: data)
                currentUser.profilePicture = downloadedImage
                print("Successfully fetched user's profile picture")
                completion(true)
            }
        }
    }
    
    func fetchUserSkipSignIn() {
        guard let authUser = Auth.auth().currentUser else {return}
        let signInUser = User(uid: authUser.uid)
        self.currentUser = signInUser
        let ref = self.firebaseDB.collection("users").document(signInUser.uid)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            let name = snapshot?.get("name") as! String
            self.currentUser?.name = name
        }
        
    }
    
    //MARK: UPDATE FUNCTIONS
    func updateProfilePic(image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = currentUser else {completion(false);return}
        let uploadRef = Storage.storage().reference(withPath: "profilePicture/\(currentUser.uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {completion(false);return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            currentUser.profilePicture = image
            completion(true)
        }
    }
    
    func updateUser(name: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let userID = currentUser?.uid else {return}
        firebaseDB.collection("users").document(userID).setData([
            "name" : name
        ]) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            self.currentUser?.name = name
            completion(true)
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
    
    func blockUser(with uid: String) {
        print("blocked user with id \(uid)")
    }
}
