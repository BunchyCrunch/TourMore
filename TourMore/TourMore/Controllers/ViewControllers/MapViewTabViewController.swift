//
//  MapViewTabViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/21/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import MapKit

class MapViewTabViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        setupLabel()
        setupButtons()
        setupSearchBar()
        setupNavagationBar()
    }
    
    func setupNavagationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    // navigationController?.navigationBar.barStyle = .black
    // navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    func setupLabel() {
      //  let labelBold = NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
      //      exploreLabel.attributedText =  labelBold
        exploreLabel.text = "EXPLORE NEARBY CUISINE"
        exploreLabel.textAlignment = .center
        
    }
    func setupButtons () {
        popularButton.setBackgroundImage(UIImage(named: "Star"), for: .normal)
        breakfastButton.setBackgroundImage(UIImage(named: "Breakfast"), for: .normal)
        lunchButton.setBackgroundImage(UIImage(named: "Lunch"), for: .normal)
        dinnerButton.setBackgroundImage(UIImage(named: "Dinner"), for: .normal)
    }

    func setupSearchBar() {
        locationSearchBar.searchBarStyle = .minimal
        locationSearchBar.placeholder = "Search"

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
