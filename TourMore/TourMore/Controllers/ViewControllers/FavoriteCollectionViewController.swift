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
    
    var locations: [Business] = []
    
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
        let location = locations[indexPath.item]
        cell.business = location
        if location.isUserGenerated == false {
                        BusinessSearchController.sharedInstance.fetchImage(businessImage: location) { (image) in
                            if let image = image {
                                DispatchQueue.main.async {
                                    cell.businessImageView.image = image
                                }
                            }
                        }
        } else {
            // ToDo: -
            // search fireBase for photo
        }
        cell.businessNameLabel.text = locations[indexPath.item].name
     //   cell.discriptionLabel.text = locations[indexPath.item].categories[title]
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
        self.present(viewController, animated: true, completion: nil)
    }
}


