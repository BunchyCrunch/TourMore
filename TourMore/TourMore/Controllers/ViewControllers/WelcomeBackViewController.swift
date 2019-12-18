//
//  WelcomeBackViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/2/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class WelcomeBackViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var currentNonce: String?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppleButton()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func continueWithAppleSignIn(_ sender: UIButton) {
        handleAuthorizationAppleID()
    }
    
    @IBAction func closeViewButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.view.window?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        }
    }
    
    @IBAction func attemptSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                textFieldIsMissingTextAlert(); return
        }
        UserController.shared.fetchUser(with: email, password: password) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setUpAppleButton() {
        appleSignInButton.layer.borderColor = UIColor.black.cgColor
        appleSignInButton.layer.borderWidth = 2
        appleSignInButton.layer.cornerRadius = 5
        appleSignInButton.clipsToBounds = true
    }
    
    @objc func keyboardWillShow(sender: Notification) {
            self.view.frame.origin.y = -150 // Move view 150 points upward
       }

       @objc func keyboardWillHide(sender: Notification) {
            self.view.frame.origin.y = 0 // Move view to original position
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
            
    request.requestedScopes = [.fullName,.email]
            
            let nonce = randomNonceString()
            currentNonce = nonce
            
            request.nonce = sha256(nonce)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = self
            controller.presentationContextProvider = self
            
            controller.performRequests()
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                guard let firstName = appleIDCredential.fullName?.givenName,
                    let lastName = appleIDCredential.fullName?.familyName else {
                        return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce, accessToken: nonce)
                UserController.shared.signInWithApple(credential: credential) { (success) in
                    if success {
                        UserController.shared.updateAppleUserGivenName(first: firstName, last: lastName) { (success) in
                            if success {
                               DispatchQueue.main.async {
                                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
        
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: Array<Character> =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length
            
            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    }
                    return random
                }
                
                randoms.forEach { random in
                    if length == 0 {
                        return
                    }
                    
                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }
            
            return result
        }
        
        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            
            return hashString
        }
    }
