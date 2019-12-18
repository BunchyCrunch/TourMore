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
    var name: String
    var uid: String
    var profilePicture: UIImage?
    var comment: [String]
    var createdComments: [Comment] = []
    var favoritesID: [String]
    var favBusinesses: [Business] = []
    var userAccessToken: String?
    var isAppleUser: Bool
    var blockedCommentIDs: [String]
    var blockedComment: [Comment]? = []
    
    var firstName: String {
        return name.components(separatedBy: " ").first ?? ""
    }
    
    init(favoritesID: [String] = [], comment: [String] = [], blockedCommentIDs: [String] = [], name: String = "", uid: String, userAccessToken: String? = nil, isAppleUser: Bool, profilePicture: UIImage? = nil) {
        self.favoritesID = favoritesID
        self.comment = comment
        self.blockedCommentIDs = blockedCommentIDs
        self.name = name
        self.uid = uid
        self.userAccessToken = userAccessToken
        self.isAppleUser = isAppleUser
        self.profilePicture = profilePicture
    }
}
