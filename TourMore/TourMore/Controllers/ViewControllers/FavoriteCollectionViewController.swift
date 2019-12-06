//
//  FavoriteCollectionViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/6/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit


class FavoriteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let reuseIdentifier = "favoriteCell"
    
    //var locations: [Business] = []
   var locations: [CreatedLocation?] = [CreatedLocation(name: "mike", address1: "mike", address2: "mike", city: "mike", country: "mike", zipCode: "mike", businessID: "mike", locationDiscription: "mike", categories: "mike")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavoriteLocations()
    }

    // MARK: - Methods
    
    func getFavoriteLocations() {
        // todo find fasvorite locations
    }
    
    

    

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return locations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
//        let location = locations[indexPath.item]
//            BusinessSearchController.sharedInstance.fetchImage(businessImage: location) { (image) in
//                if let image = image {
//                    DispatchQueue.main.async {
//                        cell.ratingImageView.image = image
//                        //  cell.businessImageView.image
//                    }
//                }
//            }
        cell.businessNameLabel.text = locations[indexPath.item]?.name
        cell.discriptionLabel.text = locations[indexPath.item]?.categories
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: UIScreen.main.bounds.width - 16, height: 260)
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetStoryboardName = "Map"
        let targetStoryboard = UIStoryboard(name: targetStoryboardName, bundle: nil)
        guard let viewController = targetStoryboard.instantiateViewController(identifier: "LocationDetail") as? LocationDetailViewController else { return }
        // uncomment after protocall or switch location var on top
      //  viewController.location = location[indexPath.item]
        self.present(viewController, animated: true, completion: nil)
    }
}


