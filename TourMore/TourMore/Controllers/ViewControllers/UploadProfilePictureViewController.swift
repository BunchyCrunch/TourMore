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
    
    var image: UIImage?
    weak var photoPickerVC: PhotoPickerViewController?
    var currentUser = UserController.shared.currentUser
    
    @IBOutlet weak var profilePictureView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startExploringButtonTapped(_ sender: UIButton) {
        updateUserProfilePicture()
    }
    
    
    func updateUserProfilePicture() {
        guard let image = image else {return}
        UserController.shared.updateProfilePic(image: image) { (success) in
            if success {
                //Move to home
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
            destinationVC?.profilePhotoImageView.image = #imageLiteral(resourceName: "Upload Image Button Copy.png")
        }
    }
}

extension UploadProfilePictureViewController: PhotoSelectorDelegate {
    func photoSelectorDidSelect(_ photo: UIImage) {
        self.image = photo
    }
}
