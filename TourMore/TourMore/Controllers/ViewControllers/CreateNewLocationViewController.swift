//
//  CreateNewLocationViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class CreateNewLocationViewController: UIViewController {
    
    // MARK: - Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Actions
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    private func needToLogInAlert() {
        let needToLogin = UIAlertController(title: "You need to login to save a location", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        needToLogin.addAction(okayButton)
        self.present(needToLogin, animated: true)
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
