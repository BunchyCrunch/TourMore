//
//  CreateNewLocationViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class CreateNewLocationViewController: UITableViewController, CLLocationManagerDelegate, UITextViewDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var locationDiscriptionTextView: UITextView!
    @IBOutlet weak var categoriesTextView: UITextView!
    @IBOutlet weak var comment: UITextView!
    
    var locationServiceManager = CLLocationManager()
    var location = CLLocation()
    var locationCheck: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleVerticalPositionAdjustment(for: UIBarMetrics(rawValue: -5)!)
        self.navigationItem.title = "Add New Location"
        setupPlaceHolderText()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any){
    // change over when user can log in
      //  doesUserExist()
        addNewLocation()
    }
    @IBAction func useCurrentLocationButtonTapped(_ sender: Any) {
        startLocating()
        getLocation()
    }
    
    
    // MARK: - Methods
    func doesUserExist(){
        if Auth.auth().currentUser != nil {
            // change when func completed
          //  doesLocationExist()
            addNewLocation()
        } else {
            needToLogInAlert()
        }
    }
    
    func setupPlaceHolderText(){
        locationDiscriptionTextView.delegate = self
        locationDiscriptionTextView.text = "Discription"
        locationDiscriptionTextView.textColor = .lightGray
        locationDiscriptionTextView.layer.borderWidth = 0.7
        locationDiscriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        locationDiscriptionTextView.layer.cornerRadius = 5
        categoriesTextView.delegate = self
        categoriesTextView.text = "Categories"
        categoriesTextView.textColor = .lightGray
        categoriesTextView.layer.borderWidth = 0.7
        categoriesTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        categoriesTextView.layer.cornerRadius = 5
        comment.layer.borderWidth = 0.7
        comment.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        comment.layer.cornerRadius = 5
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if locationDiscriptionTextView.textColor == .lightGray {
            locationDiscriptionTextView.text = ""
            locationDiscriptionTextView.textColor = .black
        } else if categoriesTextView.textColor == .lightGray {
            categoriesTextView.text = ""
            categoriesTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if locationDiscriptionTextView.text.isEmpty {
            locationDiscriptionTextView.text = "Placeholder"
            locationDiscriptionTextView.textColor = .lightGray
        } else if categoriesTextView.text.isEmpty {
            categoriesTextView.text = "Categories"
            categoriesTextView.textColor = .lightGray
        }
    }
    
    func doesLocationExist(name: String){
        getLocation()
        guard let name = businessNameTextField.text,
            !name.isEmpty  else {
                needToFillInAllFields()
                return }
        let location = self.locationCheck
        guard let search = BusinessSearchController.sharedInstance.getSearchTermQueryItem(for: name) else {return}
        BusinessSearchController.sharedInstance.getSearch(location: "\(location)", queryItems: [search]) { (business) in
            if  {
            }
        } else {
            addNewLocation()
        }
    }
    
    func addNewLocation() {
        guard let businessName = businessNameTextField.text,
            !businessName.isEmpty,
            let address1 = address1TextField.text,
            !address1.isEmpty,
            let city = cityTextField.text,
            !city.isEmpty,
            let country = countryTextField.text,
            !country.isEmpty,
            let zipCode = zipCodeTextField.text,
            !zipCode.isEmpty,
            let locationDiscription = locationDiscriptionTextView.text,
            locationDiscriptionTextView.text != "Discription",
            let categories = categoriesTextView.text,
            categoriesTextView.text != "Categories"
            else {
                self.needToFillInAllFields()
                return
        }
        let address2 = address2TextField.text ?? ""
        CreatedLocationController.addNewLocation(businessName: businessName, address1: address1, address2: address2, city: city, country: country, zipCode: zipCode, locationDiscription: locationDiscription, categories: categories) { (success, error ) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
        }
        locationCreated()
        return
    }
    
    // MARK: - Alert Controllers Methods
    func needToLogInAlert() {
        let needToLogin = UIAlertController(title: "You need to login to save a location", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        needToLogin.addAction(okayButton)
        self.present(needToLogin, animated: true)
    }
    
    func needToAllowLocationServices() {
        let allowLocationServices = UIAlertController(title: "Please allow location services to use this feature", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        allowLocationServices.addAction(okayButton)
        self.present(allowLocationServices, animated: true)
    }
    
    func needToFillInAllFields() {
        let fillAllFeilds = UIAlertController(title: "Please check that all fields are filled in", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        fillAllFeilds.addAction(okayButton)
        self.present(fillAllFeilds, animated: true)
    }
    
    func locationCreated() {
        let locationCreated = UIAlertController(title: "This New location has been saved", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        locationCreated.addAction(okayButton)
        self.present(locationCreated, animated: true)
    }
    
    func locationHasAlreadyBeenCreated(){
        let alert = UIAlertController(title: "This location already exists", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "OKAY", style: .destructive, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    
    // MARK: - Location Methods
    func getLocation() {
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
            CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                locationServiceManager.requestWhenInUseAuthorization()
            } else {
                locationManager(locationServiceManager, didUpdateLocations: [location])
            }
        } else {
            needToAllowLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let lastLocation = locationObj
        convertlocation(location: lastLocation) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func convertlocation(location: CLLocation, completion: CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else if let placemarks = placemarks {
              //  let placemark = placemarks.last as? CLPlacemark
                let placemark = placemarks.last
                self.address1TextField.text = placemark?.name
              //  self.address2TextField.text = placemark?.subThoroughfare
                self.cityTextField.text = placemark?.locality
                self.countryTextField.text = placemark?.country
                self.zipCodeTextField.text = placemark?.postalCode
                self.locationCheck = "\(String(describing: placemark?.name)), \(String(describing: placemark?.locality)), \(String(describing: placemark?.postalCode))"
                self.locationServiceManager.stopUpdatingLocation()
            }
        }
    }
    
    func startLocating() {
        locationServiceManager.delegate = self
        locationServiceManager.desiredAccuracy = kCLLocationAccuracyBest
        locationServiceManager.requestAlwaysAuthorization()
        locationServiceManager.startUpdatingLocation()
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

