//
//  SignUpViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class SignUpViewController: UIViewController {
    
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if Auth.auth().currentUser != nil {
//            UserController.shared.fetchUserSkipSignIn()
//            performSegue(withIdentifier: "", sender: self)
//        }
        setUpTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInWithAppleButtonTapped(_ sender: UIButton) {
        handleAuthorizationAppleID()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                presentFillOutFieldsAlert(); return
        }
        UserController.shared.createUser(email: email, password: password) { (success) in
            if success {
                self.presentUploadProfilePicVC()
                //Need to take in name somewhere
            }
        }
    }
    
    func saveUserNameToFireBase() {
        guard var name = nameTextField.text else {return}
        if !name.isEmpty {
            UserController.shared.updateUser(name: name) { (success) in }
        } else {
            name = ""
        }
    }
    
    func setUpTextFields() {
        Utilities.textFieldSignUpStyle(emailTextField)
        Utilities.textFieldSignUpStyle(passwordTextField)
        Utilities.textFieldSignUpStyle(nameTextField)
    }
    
    func presentFillOutFieldsAlert() {
        let alert = UIAlertController(title: "Please Fill Out All Required Feilds", message: "You must fillout all required text in order to create an account", preferredStyle: .alert)
        let dismissButton = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(dismissButton)
    }
    
    func presentUploadProfilePicVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "UploadProfilePic", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            viewController.modalPresentationStyle = .automatic
            self.present(viewController, animated: true)
        }
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

extension SignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    func handleAuthorizationAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
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
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce, accessToken: nonce)
            UserController.shared.signInWithApple(credential: credential) { (success) in
                if success {
                    self.presentUploadProfilePicVC()
                    print("Create User")
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

