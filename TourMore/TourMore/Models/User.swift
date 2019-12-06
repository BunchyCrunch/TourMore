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
    var profilePicture: UIImage?
    var comment: [String]
    var userAccessToken: String?
    //var blockedUser: [Sting] -> String == User.uuid
    
    init(favoritesID: [String] = [], comment: [String] = [], name: String = "", uid: String, userAccessToken: String? = nil, profilePicture: UIImage? = nil) {
        self.favoritesID = favoritesID
        self.comment = comment
        self.name = name
        self.uid = uid
        self.userAccessToken = userAccessToken
        self.profilePicture = profilePicture
    }
}
