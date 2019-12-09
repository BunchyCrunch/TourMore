//
//  WelcomeBackViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/2/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import AuthenticationServices

class WelcomeBackViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func continueWithAppleSignIn(_ sender: UIButton) {
        handleAuthorizationAppleID()
    }
    
    @IBAction func closeViewButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func attemptSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                textFieldIsMissingTextAlert(); return
        }
        UserController.shared.fetchUser(with: email, password: password) { (success) in
            
        }
    }

    func textFieldIsMissingTextAlert() {
        let alert = UIAlertController(title: "Missing Email or Password", message: "Please Check fields and try again", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .cancel) { (_) in }
        
        alert.addAction(okayButton)
        present(alert, animated: true)
    }

}



extension WelcomeBackViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    func handleAuthorizationAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}
