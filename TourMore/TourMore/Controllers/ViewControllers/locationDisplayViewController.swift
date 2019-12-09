//
//  locationDisplayViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class locationDisplayViewController: UIViewController,
UISearchBarDelegate {
    
    // landing pad
    var locations: [Business] = []
    var userLocationForSearch: String?
    
    
    // MARK: - Outlets
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationSearchBar.delegate = self
        setupViews()
    }
    
    // MARK: - Actions
    
    
    
    
    // MARK: - ViewSetup
    
    func setupViews() {
       // locationCollectionView.isPagingEnabled = true
       // catagoryLabel.text = locations. ?? "Catagory"

    }
    
    // MARK: - Methods

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let userlocation = userLocationForSearch,
            let searchBar = locationSearchBar.text,
            let search = BusinessSearchController.sharedInstance.getSearchTermQueryItem(for: searchBar) else { return }
        print(searchBar)
        BusinessSearchController.sharedInstance.getSearch(location: userlocation, queryItems: [search]) { (businesses) in
            if businesses.count == 0 {
                // search fireBase
            } else {
                self.locations = businesses
                DispatchQueue.main.async {
                    self.locationCollectionView.reloadData()
                }
            }
        }
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destenationVC = segue.destination as? LocationDetailViewController,
                let indexPath = locationCollectionView.indexPathsForSelectedItems?.first
                else {return}
            let location = locations[indexPath.row]
            destenationVC.location = location
        }
     }
}

extension locationDisplayViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? LocationDisplayCollectionViewCell else { return UICollectionViewCell() }
        let location = locations[indexPath.item]
        cell.businessLocation = location
        //ToDO - add turinary for nil value if there is any 
       // catagoryLabel.text = locations[indexPath.item].categories.first?.title
        catagoryLabel.text = location.categories[0].title
            return cell
    }
}

extension locationDisplayViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20)
        let hight = (view.frame.height)
        return CGSize(width: width, height: hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
}
