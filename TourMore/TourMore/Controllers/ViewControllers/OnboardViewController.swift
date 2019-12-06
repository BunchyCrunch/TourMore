//
//  OnboardViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/6/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class OnboardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipSignIn()
    }
    
    //MARK:- Actions
    @IBAction func exploreGoButtonTapped(_ sender: UIButton) {
        exploreWithoutProfile()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        //Might not be needed
    }
    
    //MARK:- Helper Functions
    func skipSignIn() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser != nil {
                UserController.shared.fetchUserSkipSignIn()
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
        }
    }
    
    func exploreWithoutProfile() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
        }
    }
}
