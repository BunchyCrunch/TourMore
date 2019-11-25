//
//  Location.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation



class CreatedLocation {
    
    var businessName: String
    var address1: String
    var address2: String
    var city: String
    var country: String
    // zip code is string since some countries have letters in the zip code IE Canada
    var zipCode: String
    var businessID: String
    
    init(businessName: String, address1: String, address2: String, city: String, country: String, zipCode: String, businessID: String = UUID().uuidString){
        self.businessName = businessName
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.country = country
        self.zipCode = zipCode
        self.businessID = businessID
    }
}



