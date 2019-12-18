//
//  YelpAPIModel.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation

struct BusinessStringKeys {
    static let name = "businessName"
    static let location = "location"
    static let addressOne = "address1"
    static let addressTwo = "address2"
    static let city = "city"
    static let country = "country"
    static let zipCode = "zipCode"
    static let businessID = "businessID"
    static let categories = "categories"
    static let alias = "alias"
    static let title = "title"
    static let coordinates = "coordinates"
    static let lat = "lat"
    static let lng = "lng"
    static let locationDescription = "locationDescription"
}

struct TopLevelJSON: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: String?
    let siteUrl: String?
    let reviewCount: Int
    let categories: [Categories]
    let coordinates: Coordinates
    let rating: Double
    let price: String?
    let location: Location
    let phoneNumber: String
    let description: String?
    var isUserGenerated: Bool = false
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case siteUrl = "url"
        case reviewCount = "review_count"
        case categories
        case coordinates
        case rating
        case price
        case location
        case phoneNumber = "display_phone"
        case description
    }
    
    var dictionary: [String : Any] {
        let locationDict = [BusinessStringKeys.addressOne : location.addressOne,
                            BusinessStringKeys.addressTwo : location.addressTwo!,
                            BusinessStringKeys.city : location.city,
                            BusinessStringKeys.country : location.country,
                            BusinessStringKeys.zipCode : location.zipCode]
        let coordinatesDict = [BusinessStringKeys.lat : coordinates.latitude,
                               BusinessStringKeys.lng : coordinates.longitude]
        let categoriesDict = categories.map({ [BusinessStringKeys.title : $0.title, BusinessStringKeys.alias : $0.alias] })
        return [BusinessStringKeys.businessID : id,
                BusinessStringKeys.name : name,
                BusinessStringKeys.locationDescription : description ?? "",
                BusinessStringKeys.location : locationDict,
                BusinessStringKeys.categories : categoriesDict,
                BusinessStringKeys.coordinates : coordinatesDict]
    }
}

extension Business {
    init?(dictionary: [String : Any] ) {
        guard let name = dictionary[BusinessStringKeys.name] as? String,
            let location = dictionary[BusinessStringKeys.location] as? [String : String],
            let addressOne = location[BusinessStringKeys.addressOne],
            let addressTwo = location[BusinessStringKeys.addressTwo],
            let city = location[BusinessStringKeys.city],
            let country = location[BusinessStringKeys.country],
            let zipCode = location[BusinessStringKeys.zipCode],
            let businessID = dictionary[BusinessStringKeys.businessID] as? String,
            let categories = dictionary[BusinessStringKeys.categories] as? [[String : String]],
            let firstCategory = categories.first,
            let alias = firstCategory[BusinessStringKeys.alias],
            let title = firstCategory[BusinessStringKeys.title],
            let coordinates = dictionary[BusinessStringKeys.coordinates] as? [String : Double],
            let lat = coordinates[BusinessStringKeys.lat],
            let lng = coordinates[BusinessStringKeys.lng],
            let locationDescription = dictionary[BusinessStringKeys.locationDescription] as? String
            else {return nil}
        
        let foundLocation = Location(addressOne: addressOne, addressTwo: addressTwo, addressThree: "", city: city, zipCode: zipCode, country: country, state: "", displayAddress: nil)
        let category = Categories(alias: alias, title: title)
        let foundCoordinates = Coordinates(latitude: lat, longitude: lng)
        
        self.id = businessID
        self.name = name
        self.imageUrl = nil
        self.siteUrl = nil
        self.reviewCount = 0
        self.categories = [category]
        self.coordinates = foundCoordinates
        self.rating = 0
        self.price = nil
        self.location = foundLocation
        self.phoneNumber = ""
        self.description = locationDescription
        self.isUserGenerated = true
    }
}

struct Categories: Codable {
    let alias: String
    let title: String
}
struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}
struct Location: Codable {
    let addressOne: String
    let addressTwo: String?
    let addressThree: String?
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let displayAddress: [String]?
    private enum CodingKeys: String, CodingKey {
        case addressOne = "address1"
        case addressTwo = "address2"
        case addressThree = "address3"
        case city
        case zipCode = "zip_code"
        case country
        case state
        case displayAddress = "display_address"
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.displayAddress == rhs.displayAddress
    }
}

extension Business: BusinessLocation {
    
}

extension Categories: Equatable {
    static func == (lhs: Categories, rhs: Categories) -> Bool {
        return lhs.alias == rhs.alias &&
            lhs.title == rhs.title
    }
}

extension Business: Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.id == rhs.id
    }
}
