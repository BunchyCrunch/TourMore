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
import FirebaseStorage

class CreatedLocationController {
    
    static let ref: DatabaseReference = Database.database().reference()
    

    // MARK: - CRUD
    static func addNewLocation(businessName: String, address1: String, address2: String, city: String, country: String, zipCode: String, locationDiscription: String, categories: String, completion: @escaping (CreatedLocation?, Error?) -> Void) {
        let uuid = UUID().uuidString
        let location = CreatedLocation(businessName: businessName, address1: address1, address2: address2,  city: city, country: country, zipCode: zipCode, businessID: uuid, locationDiscription: locationDiscription, categories: categories)
        
        ref.child("CreatedLocation").child(uuid).setValue(location.dictionary) { (error, _) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func createLocationPicture(businessID: String, image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        let uploadRef = Storage.storage().reference(withPath: "locationPicture/\(businessID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {completion(false);return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
           // createdBusiness?.businessID = image
            completion(true)
            print("photo uploaded")
        }
    }
    
    // MARK: - methods
}


