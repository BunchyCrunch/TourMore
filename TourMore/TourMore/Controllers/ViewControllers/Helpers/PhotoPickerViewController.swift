//
//  PhotoPicker.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/2/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import AVFoundation

protocol PhotoSelectorDelegate: class {
    func photoSelectorDidSelect(_ photo: UIImage)
}

class PhotoPickerViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoSelectorDelegate?
    
    
    @IBOutlet weak var pickedPhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // let bgImage: UIImage = isLoggingIn ? LoginImage : PhotoPickerImage
        // profile.image = bgImage
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        
        present(alertController, animated: true)
    }
    
    
    func presentMediaNotAvalible() {
        let errorAlertController = UIAlertController(title: "Error", message: "Media access is denied, please check your settings to be sure Recyclr has access to Media", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsURL = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsURL {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        errorAlertController.addAction(cancelAction)
        errorAlertController.addAction(settingsAction)
        present(errorAlertController, animated: true)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = UserController.shared.currentUser else {return}
            self.pickedPhotoImageView.image = user.profilePicture
        }
    }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            presentMediaNotAvalible()
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            presentMediaNotAvalible()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info[.originalImage] as? UIImage {
            delegate?.photoSelectorDidSelect(pickedimage)
            pickedPhotoImageView.image = pickedimage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
