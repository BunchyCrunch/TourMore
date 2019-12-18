//
//  SettingsTableViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/9/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var signOutCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func presentAlertForAppleUser() {
        let alert = UIAlertController(title: "ATTENTION", message: "As an apple-signIn user you are able to sign out. However, if you choose to sign out you will have to re-Sign in to you apple accout. If you would like your account to auto sign in please cancel.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            guard let user = UserController.shared.currentUser else {return}
            UserController.shared.signOutUser(user: user) { (success) in
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = UIStoryboard(name: "WelcomeBack", bundle: nil).instantiateInitialViewController()
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(signOut)
        present(alert, animated: true)
    }
    
    @IBAction func signOutUserButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        
        if user.isAppleUser == true {
            presentAlertForAppleUser()
        } else if user.isAppleUser == false {
            UserController.shared.signOutUser(user: user) { (success) in
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = UIStoryboard(name: "WelcomeBack", bundle: nil).instantiateInitialViewController()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.init(0.1)
    }
}
