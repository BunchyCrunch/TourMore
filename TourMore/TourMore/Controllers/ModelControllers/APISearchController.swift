//
//  APISearchController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
class BusinessSearchController {
    //SOT
    static let sharedInstance = BusinessSearchController()
    func getSearch(location: String, queryItems: [URLQueryItem], completion: @escaping ([Business]) -> Void) {
        guard var url = URL(string: URLConstants.baseURL) else {
            completion([]); return
        }
        url.appendPathComponent(URLConstants.business)
        url.appendPathComponent(URLConstants.search)
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion([]); return
        }
        let locationQuery = URLQueryItem(name: URLConstants.location, value: location)
        var items = queryItems
        items.append(locationQuery)
        urlComponents.queryItems = items
        guard let finalUrl = urlComponents.url else {
            print("Final URL can not get back JSON Data")
            completion([]); return
        }
        var request = URLRequest(url: finalUrl)
        request.addValue(URLConstants.auhorizationToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion([]); return
            }
            guard let data = data else {
                print("Data could not equal data")
                completion([]); return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let searchDecoder = try jsonDecoder.decode(TopLevelJSON.self, from: data)
                completion(searchDecoder.businesses)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }.resume()
    }
    func getPriceQueryItem(for price: String? = nil) -> URLQueryItem? {
        if let price = price {
            let queryItem = URLQueryItem(name: "price", value: price)
            return queryItem
        }
        return nil
    }
    func getCatogoryQueryItem(for categories: String? = nil) -> URLQueryItem? {
        if let categories = categories {
            let queryItem = URLQueryItem(name: "categories", value: categories)
            return queryItem
        }
        return nil
    }
    func getSearchTermQueryItem(for searchTerm: String? = nil) -> URLQueryItem? {
        if let searchTerm = searchTerm {
            let queryItem = URLQueryItem(name: "term", value: searchTerm)
            return queryItem
        }
        return nil
    }
    func getAttributesQueryItem(for attributes: String? = nil) -> URLQueryItem? {
        if let attributes = attributes {
            let queryItem = URLQueryItem(name: "attributes", value: attributes)
            return queryItem
        }
        return nil
    }
//    func getCoordinates(lat: Double? = nil, long: Double? = nil) -> URLQueryItem {
//        if let lat = lat {
//            let queryItem = URLQueryItem(name: "latitude", value: "\(lat)")
//            return queryItem
//        }
//    }
    func fetchImage(businessImage: Business, completion: @escaping (UIImage?) -> Void) {
        guard let imageString = businessImage.imageUrl else {return}
        guard let imageURL = URL(string: imageString) else {
            completion(nil); return
        }
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil); return
            }
            guard let data = data else {
                print("Couldnt set image data to data")
                completion(nil); return
            }
            guard let image = UIImage(data: data) else {
                completion(nil); return
            }
            completion(image)
        }.resume()
    }
}
