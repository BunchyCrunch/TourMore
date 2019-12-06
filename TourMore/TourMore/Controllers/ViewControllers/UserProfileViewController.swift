//
//  UserProfileViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth


class UserProfileViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var userProfilePictureStaticImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userInformationView: UIView!
    
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            hideViews()
            presentMustBeSignedInAlert()
        } else {
            setUpViews()
        }
    }
    
    
    func setUpViews() {
        setUpUserInformationView()
    }
    
    func setUpUserInformationView() {
        containerView.clipsToBounds = true
        userInformationView.layer.borderWidth = 3
        userInformationView.layer.borderColor = UIColor(named: "userView")?.cgColor
        userInformationView.layer.cornerRadius = view.frame.height/200
        
        userProfilePictureStaticImageView.layer.borderWidth = 1
        userProfilePictureStaticImageView.layer.masksToBounds = false
        userProfilePictureStaticImageView.clipsToBounds = true
        userProfilePictureStaticImageView.layer.borderColor = UIColor(named: "userView")?.cgColor
        userProfilePictureStaticImageView.layer.cornerRadius = userProfilePictureStaticImageView.frame.size.height/2
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.gray.cgColor
        
        guard let name = user?.name else {return}
        if name != "" {
            usersNameLabel.text = name
        } else {
            usersNameLabel.isHidden = true
        }
        
        //        guard let location =
    }
    
    func presentMustBeSignedInAlert() {
        let alert = UIAlertController(title: "You must be signed up to use this tab", message: nil, preferredStyle: .alert)
        let goToSign = UIAlertAction(title: "Sign Up", style: .default) { _ in
            //send user to sign up screen
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
