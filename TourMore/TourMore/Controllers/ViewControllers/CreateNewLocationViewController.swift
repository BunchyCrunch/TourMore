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
    var image: UIImage?
    weak var photoPickerVC: PhotoPickerViewController?
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
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIView!
    
    var locationServiceManager = CLLocationManager()
    var location = CLLocation()
    var locationCheck: String = ""
    var locationCoordantes = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.titleVerticalPositionAdjustment(for: UIBarMetrics(rawValue: -5)!)
        self.navigationItem.title = "Add New Location"
        setupPlaceHolderText()
        setupButtons()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any){
    // change over when user can log in
      //  doesUserExist()
      //  addNewLocation()
        guard let name = businessNameTextField.text,
        !name.isEmpty else {
            needToFillInAllFields()
            return }
        doesLocationExist(name: name)
    }
    
    @IBAction func useCurrentLocationButtonTapped(_ sender: Any) {
        startLocating()
        getLocation()
    }
    

    
    // MARK: - Methods
    func setupButtons() {
        locationButton.layer.cornerRadius = 5
        locationButton.frame.size = CGSize(width: 190,height: 47)
        saveButton.layer.cornerRadius = 5
        saveButton.frame.size = CGSize(width: 190, height: 47)
    }
    
    func doesUserExist(){
        guard let name = businessNameTextField.text,
        !name.isEmpty  else {
            needToFillInAllFields()
            return }
        if Auth.auth().currentUser != nil {
            doesLocationExist(name: name)
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
        categoriesTextView.text = "Tags ie (Cheap Food, Kid Friendly, Quick)"
        categoriesTextView.textColor = .lightGray
        categoriesTextView.layer.borderWidth = 0.7
        categoriesTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        categoriesTextView.layer.cornerRadius = 5
        comment.delegate = self
        comment.text = "Enter Comment"
        comment.textColor = .lightGray
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
        } else if comment.textColor == .lightGray {
            comment.text = ""
            comment.textColor = .black
        }
    }
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if locationDiscriptionTextView.text.isEmpty {
                locationDiscriptionTextView.text = "Discription"
                locationDiscriptionTextView.textColor = .lightGray
            } else if categoriesTextView.text.isEmpty {
                categoriesTextView.text = "Tags ie (Cheap Food, Kid Friendly, Quick)"
                categoriesTextView.textColor = .lightGray
            } else if comment.text.isEmpty {
                comment.text = "Enter Comment"
                comment.textColor = .lightGray
            }
        }
    
    func getLocationCheck () {
        if locationCheck != "" {
            return
        } else {
            guard let address = address1TextField.text,
                let city = cityTextField.text,
                let zipcode = zipCodeTextField.text
                else { return }
            self.locationCheck = "\(address), \(city), \(zipcode)"
        }
    }
    
    func doesLocationExist(name: String){
        getLocationCheck()
        let location = self.locationCheck
        guard let search = BusinessSearchController.sharedInstance.getSearchTermQueryItem(for: name) else {return}
        BusinessSearchController.sharedInstance.getSearch(location: "\(location)", queryItems: [search]) { (businesses) in
            DispatchQueue.main.async {
                if businesses.count == 0 {
                    //TODO: - check name and Zip on fire base prior to creating location
                    
                    self.addNewLocation()
                }
                guard let businesses = businesses.first,
                    let addressUserInput = self.zipCodeTextField.text?.lowercased() else { return }
                if businesses.name.lowercased() == name.lowercased() &&
                businesses.location.zipCode.lowercased() == addressUserInput {
                    self.locationHasAlreadyBeenCreated()
                } else {
                    self.addNewLocation()
                }
            }
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
            categoriesTextView.text != "Tags ie (Cheap Food, Kid Friendly, Quick)",
            let commentText = comment.text,
            commentText != "Enter Comment"
            else {
                self.needToFillInAllFields()
                return
        }
        let address2 = address2TextField.text ?? ""
        
        BusinessSearchController.sharedInstance.saveBusinessToFirebase(with: businessName, tags: categories, description: locationDiscription, lat: locationCoordantes[0], lng: locationCoordantes[1], rating: 0, addressOne: address1, addressTwo: address2, city: city, zipCode: zipCode, country: country) { (business, error ) in
            guard let business = business else { return }
            self.addNewLocationPicture(for: business)
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            CommentController.shared.addComment(text: commentText, rating: 0, businessID: business.id) { (comment, _) in
                if let comment = comment {
                    guard let user = UserController.shared.currentUser else {return}
                    if user.isAppleUser == true {
                        UserController.shared.postCommmentForAppleUser(comment: comment)
                    } else if user.isAppleUser == false {
                        UserController.shared.postCommmentForUser(comment: comment)
                    }
                }
            }
        }
        locationCreated()
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
        let locationCreated = UIAlertController(title: "This New location has been saved", message: nil, preferredStyle: .actionSheet)
        let okayButton = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        locationCreated.addAction(okayButton)
        self.present(locationCreated, animated: true)
    }
    
    func locationHasAlreadyBeenCreated(){
        let alert = UIAlertController(title: "This location already exists", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "OKAY", style: .destructive, handler: nil)
        alert.addAction(okayButton)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func addNewLocationPicture(for bussiness: Business) {
        guard let image = image else {return}
        BusinessSearchController.createLocationPicture(businessID: bussiness.id, image: image) { (success) in
            if success {
                print("picture uploaded")
            }
        }
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
        let coord = locationObj.coordinate
        let lat = coord.latitude
        let long = coord.longitude
        self.locationCoordantes = [lat, long]
        
        
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

    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatedLocationPhotoPicker" {
            let destenationVC = segue.destination as? PhotoPickerViewController
            destenationVC?.delegate = self
            self.photoPickerVC = destenationVC
            destenationVC?.loadViewIfNeeded()
            destenationVC?.pickedPhotoImageView.image = #imageLiteral(resourceName: "Upload Image Button Copy.png")
        }
    }
}

extension CreateNewLocationViewController: PhotoSelectorDelegate {
    func photoSelectorDidSelect(_ photo: UIImage) {
        self.image = photo
    }
}
