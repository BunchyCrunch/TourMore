//
//  Location.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import Firebase

//https://medium.com/flawless-app-stories/scratching-the-firebase-services-with-your-ios-app-c2746881c6d8

class CreatedLocation {
    
    var businessName: String
    var address1: String
    var address2: String?
    var city: String
    var country: String
    // zip code is string since some countries have letters in the zip code IE Canada
    var zipCode: String
    var businessID: String
    var dictionary: [String : Any] {
        return [
            "businessName" : businessName,
            "address1" : address1,
            "address2" : address2,
            "city" : city,
            "country" : country,
            "zipCode" : zipCode,
            "businessID" : businessID
        ]
    }
    
    init(businessName: String, address1: String, address2: String?, city: String, country: String, zipCode: String, businessID: String = UUID().uuidString){
        self.businessName = businessName
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.country = country
        self.zipCode = zipCode
        self.businessID = businessID
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: AnyObject],
        businessName = snapshotValue["businessName"] as? String,
        address1 = snapshotValue["address1"] as? String,
        address2 = snapshotValue["address2"] as? String,
        city = snapshotValue["city"] as? String,
        country = snapshotValue["country"] as? String,
        zipCode = snapshotValue["zipCode"] as? String,
        businessID = snapshotValue["businessID"] as? String
    }
}



