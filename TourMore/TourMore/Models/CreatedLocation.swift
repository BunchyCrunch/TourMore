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
    var address2: String
    var city: String
    var country: String
    var zipCode: String
    var businessID: String
    var locationDiscription: String
    var categories: String
    var dictionary: [String : Any] {
        return [
            "businessName" : businessName,
            "address1" : address1,
            "address2" : address2,
            "city" : city,
            "country" : country,
            "zipCode" : zipCode,
            "businessID" : businessID,
            "categories" : categories,
            "locationDiscription" : locationDiscription
        ]
    }
    
    init(businessName: String, address1: String, address2: String = "", city: String, country: String, zipCode: String, businessID: String, locationDiscription: String, categories: String ){
        self.businessName = businessName
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.country = country
        self.zipCode = zipCode
        self.businessID = businessID
        self.locationDiscription = locationDiscription
        self.categories = categories
    }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String : Any],
            let businessName = snapshotValue["businessName"] as? String,
            let address1 = snapshotValue["address1"] as? String,
            let address2 = snapshotValue["address2"] as? String,
            let city = snapshotValue["city"] as? String,
            let country = snapshotValue["country"] as? String,
            let zipCode = snapshotValue["zipCode"] as? String,
            let businessID = snapshotValue["businessID"] as? String,
            let locationDiscription = snapshotValue["locationDiscription"] as? String,
            let categories = snapshotValue["categories"] as? String
            else {return nil}
        
        self.init(businessName: businessName, address1: address1, address2: address2, city: city, country: country, zipCode: zipCode, businessID: businessID, locationDiscription: locationDiscription, categories: categories)
    }
}



