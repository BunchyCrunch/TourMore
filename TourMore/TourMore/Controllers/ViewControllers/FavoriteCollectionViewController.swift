//
//  FavoriteCollectionViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/6/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class FavoriteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let reuseIdentifier = "favoriteCell"
    
    var locations: [Business] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var ref: DatabaseReference?
    var refStorage = Firestore.firestore()
    var favorites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //       getFavoriteLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteLocations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getFavoriteLocations()
    }
    // MARK: - Methods
    
    func getFavoriteLocations() {
        if Auth.auth().currentUser == nil {
            //  pop up controller to log in
        }
        fetchFavoritesFromUser()
        // need alert controller to log in
    }
    
    func searchRealTimeFirebase(for businessID: String){
        ref = Database.database().reference()
        ref?.child("CreatedLocation").queryEqual(toValue: businessID, childKey: "businessID")
        
    }
    
    func fetchFavoritesFromUser() {
        guard let user = UserController.shared.currentUser else { return }
        self.favorites = user.favoritesID
        for businessId in favorites {
            if businessId.count <= 24 {
                BusinessSearchController.sharedInstance.fetchBusinessForID(businessID: businessId) { (business) in
                    guard let business = business else {
                        print("business not found in favorites fetch") ; return }
                    if !self.locations.contains(business) {
                        self.locations.append(business)
                    }
                }
            } else {
                // search fire base
                
            }
        }
    }
    
//
//    func attachToLandingPad(favorites: [String]){
//        for id in favorites {
//            BusinessSearchController.sharedInstance.fetchBusinessForID(businessID: id) { (business) in
//                guard let favoriteBusiness = business else {return}
//                self.locations.append(favoriteBusiness)
//            }
//        }
//    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        let location = locations[indexPath.item]
        cell.business = location
        if location.isUserGenerated == false {
            BusinessSearchController.sharedInstance.fetchImage(businessImage: location) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
//                        let scaledImage = image.scaleImage(into: CGSize(width: cell.frame.width, height: cell.frame.height / 2))
                        cell.businessImageView.image = image
                        cell.businessImageView.clipsToBounds = true
                        cell.businessImageView.contentMode = .scaleAspectFill
                        cell.businessImageView.layer.cornerRadius = cell.businessImageView.frame.height / 40
                    }
                }
            }
        } else {
            // ToDo: -
            // search fireBase for photo
        }
        cell.businessNameLabel.text = " \(locations[indexPath.item].name)"
        cell.discriptionLabel.text = " \(locations[indexPath.item].categories.map({$0.title}).joined(separator: " "))"
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 500)
//            CGSize(width: view.bounds.width - 16, height: 260)
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetStoryboardName = "Map"
        let targetStoryboard = UIStoryboard(name: targetStoryboardName, bundle: nil)
        guard let viewController = targetStoryboard.instantiateViewController(identifier: "LocationDetail") as? LocationDetailViewController else { return }
        viewController.location = locations[indexPath.item]
        self.present(viewController, animated: true, completion: nil)
        collectionView.reloadData()
    }
}


