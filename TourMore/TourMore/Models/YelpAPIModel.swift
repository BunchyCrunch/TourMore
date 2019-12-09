//
//  YelpAPIModel.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation

struct TopLevelJSON: Decodable {
    let businesses: [Business]
}

struct Business: Decodable {
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
    }
}
struct Categories: Decodable {
    let alias: String
    let title: String
}
struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}
struct Location: Decodable {
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
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs == rhs
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
