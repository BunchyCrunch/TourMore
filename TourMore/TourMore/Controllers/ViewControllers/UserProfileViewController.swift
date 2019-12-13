//
//  UserProfileViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation


class UserProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var userProfilePictureStaticImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var profilePictureContainerView: UIView!
    
    @IBOutlet weak var saveProfilePictureButton: UIButton!
    
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var selectedImage: UIImage?
    
    weak var photoPickerVC: PhotoPickerViewController?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if Auth.auth().currentUser == nil {
//            hideViews()
//            presentMustBeSignedInAlert()
//        } else {
//            setUpViews()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Auth.auth().currentUser == nil {
                  hideViews()
                  presentMustBeSignedInAlert()
              } else {
                  setUpViews()
              }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if locationManager != nil {
        locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func saveProfilePictureChangeButtonTapped(_ sender: Any) {
        updateProfilePicture()
    }
    
    //MARK:- Helper Functions
    func setUpViews() {
        setUpUserInformationView()
    }
    
    func setUpUserInformationView() {
        containerView.clipsToBounds = true
        userInformationView.layer.borderWidth = 3
        userInformationView.layer.borderColor = UIColor(named: "userView")?.cgColor
        userInformationView.layer.cornerRadius = view.frame.height/200
        
        profilePictureContainerView.layer.borderWidth = 1
        profilePictureContainerView.layer.masksToBounds = false
        profilePictureContainerView.clipsToBounds = true
        profilePictureContainerView.layer.borderColor = UIColor(named: "userView")?.cgColor
        profilePictureContainerView.layer.cornerRadius = profilePictureContainerView.frame.size.height/2
        photoPickerVC?.pickedPhotoImageView.contentMode = .scaleAspectFill
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.gray.cgColor
        
        deterimeLocation()
        
        guard let name = UserController.shared.currentUser?.name else {return}
        if name != "" {
            usersNameLabel.text = name
        } else {
            usersNameLabel.isHidden = true
        }
        
        UserController.shared.fetchProfilePicture { (success) in
            if success {
                let image = UserController.shared.currentUser?.profilePicture
                self.photoPickerVC?.updateViews(with: image)
            }
        }
    }
    func presentMustBeSignedInAlert() {
        let alert = UIAlertController(title: "You must be signed up to use this tab", message: nil, preferredStyle: .alert)
        let goToSign = UIAlertAction(title: "Sign Up", style: .default) { _ in
            DispatchQueue.main.async {
                self.view.window?.rootViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController()
            }
        }
        let exit = UIAlertAction(title: "Exit", style: .cancel) { _ in
            //present index 1 of tab view
        }
        alert.addAction(goToSign)
        alert.addAction(exit)
        present(alert, animated: true)
    }
    
    func hideViews() {
        userProfilePictureStaticImageView.isHidden = true
        containerView.isHidden = true
        userInformationView.isHidden = true
        usersNameLabel.isHidden = true
        userLocationLabel.isHidden = true
        saveProfilePictureButton.isHidden = true
    }
    
    func deterimeLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            lookUpCurrentLocation { (placemark) in
                if (placemark != nil) {
                    DispatchQueue.main.async {
                        self.reloadInputViews()
                    }
                }
            }
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    guard let placemarks = placemarks else { return }
                                                    let firstLocation = placemarks[0]
                                                    self.userLocationLabel.text = "\(firstLocation.locality ?? "Unknow Location")" + ", " + "\(firstLocation.isoCountryCode ?? "")"
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func updateProfilePicture() {
        guard let newImage = selectedImage else {return}
        UserController.shared.deleteProfilePicture()
        UserController.shared.updateProfilePic(image: newImage) { (success) in
            if success {
                print("Deleted old image ref and set new")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfilePicture" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else {return}
            destinationVC.delegate = self
            destinationVC.profileImage = selectedImage
            self.photoPickerVC = destinationVC
        }
    }
}

extension UserProfileViewController: PhotoSelectorDelegate {
    func photoSelectorDidSelect(_ photo: UIImage) {
        self.selectedImage = photo
    }
}
