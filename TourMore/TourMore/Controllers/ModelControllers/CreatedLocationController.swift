//
//  CreatedLocationController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class CreatedLocationController {
    
    var ref: DatabaseReference!
    var databaseHandler: DatabaseHandle?
  // ref = Database.database().reference()
    
    
    // MARK: - CRUD
    func addNewLocation(businessName: String, address1: String, address2: String, city: String, country: String, zipCode: String, completion: @escaping (CreatedLocation?, Error?) -> ()) {
        if Auth.auth().currentUser != nil {
            let uuid = UUID().uuidString
            let location = CreatedLocation(businessName: businessName, address1: address1, address2: address2,  city: city, country: country, zipCode: zipCode, businessID: uuid)
            ref = Database.database().reference()
            ref.child("CreatedLocation").child(uuid).setValue(location.dictionary)
        } else {
            
        }
        
        
    }
    func deleteLocation() {
        ref = Database.database().reference()
    }
    
    func fetchLocation() {
        
    }
    
    // MARK: - methods
}


