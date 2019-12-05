//
//  locationDisplayViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class locationDisplayViewController: UIViewController,
//UICollectionViewDataSource,
UICollectionViewDelegate, UISearchBarDelegate {
    
    // landing pad
    var locations: [Business] = []
    var userLocationForSearch: String?
    
    // MARK: - Outlets
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var catagoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath, for indexPath) as? LocationDisplayCollectionViewCell
////        // cell info
////        return cell
//
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userlocation = userLocationForSearch,
            let searchBar = locationSearchBar.text,
            let search = BusinessSearchController.sharedInstance.getSearchTermQueryItem(for: searchBar) else { return }
        print(searchBar)
        BusinessSearchController.sharedInstance.getSearch(location: userlocation, queryItems: [search]) { (businesses) in
            if businesses.count == 0 {
                // search fireBase
            } else {
                self.locations = businesses
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    
    //    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of items
    //        return 0
    //    }
    
    //    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    //
    //        // Configure the cell
    //
    //        return cell
    //    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
