//
//  User.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class User {
    //Save Business ID from model
    var favoritesID: [String] //Add Strings of Buissness id
    var name: String
    var uid: String
    var bio: String
    var profilePicture: UIImage?
    var comment: [Comment]
    //var blockedUser: [Sting] -> String == User.uuid
    
    init(favoritesID: [String] = [], comment: [Comment] = [], name: String = "", uid: String, bio: String = "", profilePicture: UIImage? = nil) {
        self.favoritesID = favoritesID
        self.comment = comment
        self.name = name
        self.uid = uid
        self.bio = bio
        self.profilePicture = profilePicture
    }
    

}
