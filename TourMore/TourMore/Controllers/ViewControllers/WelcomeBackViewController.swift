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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func continueWithAppleSignIn(_ sender: UIButton) {
        handleAuthorizationAppleID()
    }
    
    @IBAction func closeViewButtonTapped(_ sender: UIButton) {
        
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
