//
//  FavoriteCollectionViewCell.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/6/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    var business: Business? {
        didSet {
            starSelectorImage(star: self.business!)
        }
    }
    
    func starSelectorImage(star: Business){
        let star = star.rating
        switch star {
        case 0.5:
            ratingImageView.image = UIImage(named: "")
        case 1.0:
            ratingImageView.image = UIImage(named: "1Star")
        case 1.5:
            ratingImageView.image = UIImage(named: "1.5Star")
        case 2.0:
            ratingImageView.image = UIImage(named: "2Star")
        case 2.5:
            ratingImageView.image = UIImage(named: "2.5Star")
        case 3.0:
            ratingImageView.image = UIImage(named: "3Star")
        case 3.5:
            ratingImageView.image = UIImage(named: "3.5Star")
        case 4.0:
            ratingImageView.image = UIImage(named: "4Star")
        case 4.5:
            ratingImageView.image = UIImage(named: "4.5Star")
        case 5.0:
            ratingImageView.image = UIImage(named: "5Star")
        default:
            ratingImageView.image = UIImage(named: "")
        }
    }
    
}
