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
    var currentUser: User? {
        didSet {
        print("currentUser set \(currentUser)")
        }
    }
    let firebaseDB = Firestore.firestore()
    
    //MARK: CREATE USER
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let user = authResult else {return}
            let newUser = User(uid: user.user.uid, isAppleUser: false)
            self.currentUser = newUser
            completion(true)
        }
    }
    
    //MARK: UPDATE FUNCTIONS
    func updateUserGivenName(name: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let userID = currentUser?.uid else {return}
        firebaseDB.collection("users").document(userID).setData([
            "name" : name,
            "favorites" : [],
            "userComments" : [],
            "isAppleUser" : false
        ]) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            self.currentUser?.name = name
            completion(true)
        }
    }
    
    
    
    func updateProfilePic(image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = currentUser else {completion(false);return}
        let uploadRef = Storage.storage().reference().child("profilePicture/\(currentUser.uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {completion(false);return}
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
    
    //MARK: FETCH FUNCTIONS
    func fetchUser(with email: String, password: String, completion: @escaping(_ successl: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let user = authResult else {return}
            let loggedInUser = User(uid: user.user.uid, isAppleUser: false)
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
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profilePicture/\(currentUser.uid).jpg")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
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
        let ref = self.firebaseDB.collection("users").document(authUser.uid)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            if snapshot != nil {
                guard let data = snapshot?.data() else {
                    self.fetchAppleUserSkipSignIn() ; return
                }
                guard let name = data["name"] as? String,
                    let favorites = data["favorites"] as? [String],
                    let comments = data["userComments"] as? [String],
                    let isAppleUser = data["isAppleUser"] as? Bool,
                    let uid = snapshot?.documentID else {
                        return
                }
                let foundUser = User(favoritesID: favorites, comment: comments, name: name, uid: uid, userAccessToken: nil, isAppleUser: isAppleUser, profilePicture: nil)
                self.currentUser = foundUser
            }
        }
    }
    
    func postCommmentForUser(comment: Comment) {
           guard let user = currentUser,
               let userID = currentUser?.uid else {return}
        firebaseDB.collection("users").document(userID).updateData(["userComments": user.comment])
       }
    
    func addFavoriteToUserFavorites(business: Business) {
        guard let user = currentUser,
            let userID = currentUser?.uid else {
                print("Cound not set user or user ID in addFavoriteForUserFavorites")
                return}
        let newFavorite = business.id
        currentUser?.favoritesID.append(newFavorite)
        currentUser?.favBusinesses?.append(business)
        firebaseDB.collection("users").document(userID).updateData(["favorites" : user.favoritesID])
    }
    

    func deleteFavoriteFromUser(business: Business){
        guard let userID = currentUser?.uid else { return }
        let locationIdToDelete = business.id
        firebaseDB.collection("users").document(userID).collection("favorite").document(locationIdToDelete).updateData([locationIdToDelete: FieldValue.delete()]) {
                   err in
                   if let err = err {
                       print("Error in \(#function) : \(err.localizedDescription) \n---\n \(err)")
                   } else {
                       print("delete successfully")
                   }
                   
               }
    }
    

    //MARK:- Sign Out Function
    func signOutUser(user: User, completion: @escaping (_ success: Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            print("Error signing out: %@")
        }
        print("signed out user")
        completion(true)
    }
    
    //MARK: APPLE USER FUNCTIONS
    
    //MARK:- Create Apple User
    func signInWithApple(credential: OAuthCredential, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard authResult != nil ,
                let accessToken = credential.accessToken,
                let uuid = authResult?.user.uid
                else { completion(false) ; return }
            
            let user = User(uid: uuid, userAccessToken: accessToken, isAppleUser: true)
            self.currentUser = user
            completion(true)
        }
    }
    
    func postCommmentForAppleUser(comment: Comment) {
        guard let user = currentUser,
            let userID = currentUser?.uid else {return}
        firebaseDB.collection("appleUsers").document(userID).updateData(["userComments": user.comment])
//        guard let user = currentUser,
//            let userID = currentUser?.uid else {return}
//        var newComments = user.createdComments?.compactMap{$0.id} ?? []
//        if let currentFBComments = firebaseDB.collection("appleUsers").document(userID).collection("userComments") {
//            newComments = currentFBComments + newComments
//        }
//        firebaseDB.collection("appleUsers").document(userID).updateData(["userComments": newComments])
    }
    
    func addFavoriteToAppleUserFavorites(business: Business) {
        guard let user = currentUser,
            let userID = currentUser?.uid
            else {
                print("Cound not set user or user ID in addFavoriteForAppleUserFavorites")
                return}
        let newFavorite = business.id
        currentUser?.favoritesID.append(newFavorite)
        currentUser?.favBusinesses?.append(business)
        firebaseDB.collection("appleUsers").document(userID).updateData(["favorites" : user.favoritesID])
    }
    

    func deleteFavoriteFromAppleUser(business: Business){
        guard let userID = currentUser?.uid else { return }
        let locationIdToDelete = business.id
        firebaseDB.collection("appleUsers").document(userID).collection("favorite").document(locationIdToDelete).updateData([locationIdToDelete: FieldValue.delete()]) {
            err in
            if let err = err {
                print("Error in \(#function) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                print("delete successfully")
            }
            
        }
    }
    

    //MARK:- Update Apple User Information in DB
    func updateAppleUserGivenName(first: String, last: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let userID = currentUser?.uid else {return}
        let name = "\(first) \(last)"
        self.currentUser?.name = name
        firebaseDB.collection("appleUsers").document(userID).setData([
            "name" : name,
            "favorites" : [],
            "userComments" : [],
            "isAppleUser" : true
        ]) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            completion(true)
        }
    }
    
    //    func updateAppleProfilePic(image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
    //        guard let currentUser = currentUser else {completion(false);return}
    //        let uploadRef = Storage.storage().reference(withPath: "appleprofilePicture/\(currentUser.uid).jpg")
    //        guard let imageData = image.jpegData(compressionQuality: 0.5) else {completion(false);return}
    //        let uploadMetaData = StorageMetadata.init()
    //        uploadMetaData.contentType = "image/jpeg"
    //        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
    //            if let error = error {
    //                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    //                completion(false)
    //            }
    //            currentUser.profilePicture = image
    //            completion(true)
    //        }
    //    }
    //
    //MARK:- Fetch Apple User AutoSignIn
    func fetchAppleUserSkipSignIn() {
        guard let authUser = Auth.auth().currentUser else {return}
        let ref = self.firebaseDB.collection("appleUsers").document(authUser.uid)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            if snapshot != nil {
                guard let data = snapshot?.data() else {return}
                guard let name = data["name"] as? String,
//                    let lastName = data["lastName"] as? String,
                    let favorites = data["favorites"] as? [String],
                    let comments = data["userComments"] as? [String],
                    let isAppleUser = data["isAppleUser"] as? Bool,
                    let uid = snapshot?.documentID
                    else {
                        print("Missing Data in FetchAppleSignIn")
                        return
                        
                }
                
                let foundAppleUser = User(favoritesID: favorites, comment: comments, name: name, uid: uid, userAccessToken: nil, isAppleUser: isAppleUser, profilePicture: nil)
                self.currentUser = foundAppleUser
                //                let name = "\(firstName) \(lastName)"
                //                if name != "" {
                //                    self.currentUser?.name = name
                //                }
            }
        }
    }
    
    //    func fetchAppleProfilePicture(completion: @escaping (_ success: Bool) -> Void) {
    //        guard let currentUser = currentUser else { return }
    //        let storageRef = Storage.storage().reference(withPath: "appleprofilepictures/\(currentUser.uid).jpg")
    //        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
    //            if let error = error {
    //                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    //                completion(false)
    //            }
    //            if let data = data {
    //                let downloadedImage = UIImage(data: data)
    //                currentUser.profilePicture = downloadedImage
    //                print("Successfully fetched user's profile picture")
    //                completion(true)
    //            }
    //        }
    //    }
}//END OF CLASS


//func blockUser(with uid: String) {
//    print("blocked user with id \(uid)")
//}
//
//
//
//let firstName = snapshot?.get("firstName") as? String,
//               let lastName = snapshot?.get("lastName") as? String
