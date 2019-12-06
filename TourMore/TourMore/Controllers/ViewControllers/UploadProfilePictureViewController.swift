//
//  UploadProfilePictureViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 11/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseStorage

class UploadProfilePictureViewController: UIViewController {
    
    //MARK:- Properties
    var image: UIImage?
    weak var photoPickerVC: PhotoPickerViewController?
    var currentUser = UserController.shared.currentUser
    
    //MARK:- Outlets
    @IBOutlet weak var profilePictureView: UIView!

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Actions
    @IBAction func startExploringButtonTapped(_ sender: UIButton) {
        updateUserProfilePicture()
        dismissOnboarding()
    }
    
    //MARK: Helper Functions
    func updateUserProfilePicture() {
        guard let image = image else {return}
        UserController.shared.updateProfilePic(image: image) { (success) in
            if success {
                //save to user
                //
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilePicturePicker" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
            self.photoPickerVC = destinationVC
            destinationVC?.loadViewIfNeeded()
            destinationVC?.pickedPhotoImageView.image = #imageLiteral(resourceName: "Upload Image Button Copy.png")
        }
    }
    
    func dismissOnboarding() {
        DispatchQueue.main.async {
            self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}

//MARK:- Picker Extention
extension UploadProfilePictureViewController: PhotoSelectorDelegate {
    func photoSelectorDidSelect(_ photo: UIImage) {
        self.image = photo
    }
}
