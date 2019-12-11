//
//  LocationDisplayCollectionViewCell.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class LocationDisplayCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var businessPhoto: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var numberOfStarsImageView: UIImageView!
    

    var businessLocation: Business? {
        didSet {
            setupViews()
        }
    }
    
    func setupViews() {
        guard let location = businessLocation else { return }
        BusinessSearchController.sharedInstance.fetchImage(businessImage: location) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.businessPhoto.image = image
                    self.businessPhoto.clipsToBounds = true
                    self.businessPhoto.contentMode = .scaleAspectFill
                    self.businessPhoto.layer.cornerRadius = self.businessPhoto.frame.height / 40
                }
            }
        }
        starSelectorImage(star: location)
        businessName.text = location.name
        categoryLabel.text = location.categories[0].title
        self.bringSubviewToFront(categoryLabel)
        discriptionLabel.text = location.categories.map({$0.title}).joined(separator: " ")
        addressLabel.text = location.location.displayAddress?.joined(separator: ", ")
        numberOfReviewsLabel.text = "\(location.reviewCount) Reviews"
    }
    
    func starSelectorImage(star: Business){
        let star = star.rating
        switch star {
        case 0.5:
            numberOfStarsImageView.image = UIImage(named: "0.5Star")
        case 1.0:
            numberOfStarsImageView.image = UIImage(named: "1Star")
        case 1.5:
            numberOfStarsImageView.image = UIImage(named: "1.5Star")
        case 2.0:
            numberOfStarsImageView.image = UIImage(named: "2Star")
        case 2.5:
            numberOfStarsImageView.image = UIImage(named: "2.5Star")
        case 3.0:
            numberOfStarsImageView.image = UIImage(named: "3Star")
        case 3.5:
            numberOfStarsImageView.image = UIImage(named: "3.5Star")
        case 4.0:
            numberOfStarsImageView.image = UIImage(named: "4Star")
        case 4.5:
            numberOfStarsImageView.image = UIImage(named: "4.5Star")
        case 5.0:
            numberOfStarsImageView.image = UIImage(named: "5Star")
        default:
            numberOfStarsImageView.image = UIImage(named: "noReview")
        }
    }
}

