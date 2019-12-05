//
//  MapViewTabViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/21/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewTabViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    private var scaleView: MKScaleView!
    private var userTrackingButton: MKUserTrackingButton!
    var userLocationForSearch: String?
    var businessArray: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        locationSearchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Actions
    
    @IBAction func popularButtonTapped(_ sender: Any){
        searchByCatogory(term: "Popular")
    }
    
    @IBAction func breakfastButtonTapped(_ sender: Any){
        searchByCatogory(term: "Breakfast")
    }
    
    @IBAction func lunchButtonTapped(_ sender: Any){
        searchByCatogory(term: "Lunch")
    }
    
    @IBAction func dinnerButtonTapped(_ sender: Any){
        searchByCatogory(term: "Dinner")
    }
    
    // MARK: - Views Setup
    func setupScreen() {
        setupLabel()
        setupButtons()
        setupSearchBar()
        setupNavagationBar()
        deterimeLocation()
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
    
    func mapSettings() {
        setupUserTrackingAndScaleView()
        mapView.showsUserLocation = true
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.mapType = .standard
        mapView.showsCompass = true
    }
    
    private func setupUserTrackingAndScaleView() {
        scaleView = MKScaleView(mapView: mapView)
        scaleView.scaleVisibility = .adaptive
        scaleView.legendAlignment = .trailing
        view.addSubview(scaleView)
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.layer.backgroundColor = UIColor.white.cgColor
        userTrackingButton.layer.borderColor = UIColor.white.cgColor
        userTrackingButton.layer.borderWidth = 1
        userTrackingButton.layer.cornerRadius = 5
        view.addSubview(userTrackingButton)
        
        let stackView = UIStackView(arrangedSubviews: [scaleView, userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
        
    }
    // MARK: - Methods
    func deterimeLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            mapSettings()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        self.userLocationForSearch = "\(center.latitude), \(center.longitude)"
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    func searchByCatogory(term: String) {
        guard let userLocation = userLocationForSearch,
        let search = BusinessSearchController.sharedInstance.getCatogoryQueryItem(for: term) else { return }
        BusinessSearchController.sharedInstance.getSearch(location: userLocation, queryItems: [search]) { (businesses) in
            self.businessArray = businesses
            self.toCollectionView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userlocation = userLocationForSearch,
            let searchBar = searchBar.text,
            let search = BusinessSearchController.sharedInstance.getSearchTermQueryItem(for: searchBar) else { return }
        print(searchBar)
        BusinessSearchController.sharedInstance.getSearch(location: userlocation, queryItems: [search]) { (businesses) in
            if businesses.count == 0 {
                // search fireBase
                self.toCollectionView()
            } else {
                self.businessArray = businesses
                self.toCollectionView()
            }
        }
    }

    
    // MARK: - Navigation
    func toCollectionView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toCollectionView", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollectionView" {
 //           guard let destenationVC = segue.destination as? LocationViewController else {return}
 //           destenationVC.locations = businessArray
        }
    }
}
