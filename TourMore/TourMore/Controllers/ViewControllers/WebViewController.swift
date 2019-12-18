//
//  WebViewController.swift
//  TourMore
//
//  Created by Christopher Alegre on 12/13/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var termsOfUseAndPrivacyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://calegre14.github.io/") else {return}
        let urlRequest = URLRequest(url: url)
        termsOfUseAndPrivacyWebView.load(urlRequest)
        
    }
}
