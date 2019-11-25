//
//  MapViewTabViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/21/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import MapKit

class MapViewTabViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupLabel() {
        //    let labelBold = NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        //    exploreLabel.attributedText =  labelBold
    }
    func setupButtons () {
        popularButton.setImage(UIImage(named: ""), for: .normal)
        breakfastButton.setImage(UIImage(named: ""), for: .normal)
        lunchButton.setImage(UIImage(named: ""), for: .normal)
        dinnerButton.setImage(UIImage(named: ""), for: .normal)
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
