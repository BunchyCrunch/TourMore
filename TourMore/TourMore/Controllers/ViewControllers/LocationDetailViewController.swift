//
//  LocationDetailViewController.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/5/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var locationPhotoImageView: UIImageView!
    @IBOutlet weak var dummyTextView: UITextView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var peekStackView: UIStackView!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dummySlideBar: UIView!
    @IBOutlet weak var separatorBar: UIView!
    
    weak var favoriteButton: UIButton!
    weak var delegate: LocationDetailViewControllerDelegate?
    
    var location: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        dummyTextView.delegate = self
        navigationController?.navigationItem.backBarButtonItem?.setBackgroundImage(UIImage(named: "Back Button"), for: .normal, barMetrics: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        delegate?.removeFavoriteToUpdateView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hideDummyStackView()
    }
    
    @IBAction func swipeUp(_ sender: Any) {
        hideDummyStackView()
    }
    
    @IBAction func swipeUpDummySlideBar(_ sender: Any) {
        hideDummyStackView()
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.favoriteButton.isHidden = false
        UIView.animate(withDuration: 0.5, animations:  {
            self.peekStackView.isHidden = false
            self.dummySlideBar.isHidden = false
            self.separatorBar.isHidden = false
            self.containerView.isHidden = true
            
        }) { (success) in
            if success {
                DispatchQueue.main.async {
                }
                print("Successfully hid drawer")
            }
        }
    }
    
    func hideDummyStackView() {
        self.favoriteButton.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.isHidden = false
            
        }) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.peekStackView.isHidden = true
                    self.dummySlideBar.isHidden = true
                    self.separatorBar.isHidden = true
                }
                print("Successfully animated drawer")
            }
        }
    }
    
    func setUpView(){
        containerView.isHidden = true
        guard let location = location else { return }
        BusinessSearchController.sharedInstance.fetchImage(businessImage: location) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.locationPhotoImageView.image = image
                    self.locationPhotoImageView.clipsToBounds = true
                    self.locationPhotoImageView.contentMode = .scaleAspectFill
                }
            }
        }
        businessName.text = location.name
        businessTypeLabel.text = location.categories.map({$0.title}).joined(separator: " ")
        addressLabel.text = location.location.displayAddress?.joined(separator: ", ")
        commentLabel.text = "\(location.reviewCount) Reviews"
        starSelectorImage(star: location)
        makeNavagationControllerClear()
        setupFavoriteButton()
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        dummySlideBar.layer.cornerRadius = 5
        dummyTextView.layer.borderWidth = 0.5
        dummyTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeNavagationControllerClear(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func starSelectorImage(star: Business){
        let star = star.rating
        switch star {
        case 0.5:
            ratingImage.image = UIImage(named: "")
        case 1.0:
            ratingImage.image = UIImage(named: "1Star")
        case 1.5:
            ratingImage.image = UIImage(named: "1.5Star")
        case 2.0:
            ratingImage.image = UIImage(named: "2Star")
        case 2.5:
            ratingImage.image = UIImage(named: "2.5Star")
        case 3.0:
            ratingImage.image = UIImage(named: "3Star")
        case 3.5:
            ratingImage.image = UIImage(named: "3.5Star")
        case 4.0:
            ratingImage.image = UIImage(named: "4Star")
        case 4.5:
            ratingImage.image = UIImage(named: "4.5Star")
        case 5.0:
            ratingImage.image = UIImage(named: "5Star")
        default:
            ratingImage.image = UIImage(named: "")
        }
    }
    
    func setupFavoriteButton() {
        let favoriteButton = UIButton()
        self.favoriteButton = favoriteButton
  //       favoriteButton.setBackgroundImage(UIImage(named: "unFilledHeart"), for: .normal)
        guard let location = self.location,
            let user = UserController.shared.currentUser
            else { return }
        if !user.favoritesID.contains(location.id) {
            favoriteButton.setBackgroundImage(UIImage(named: "unFilledHeart"), for: .normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "filledHeart"), for: .normal)
        }
        
        
        favoriteButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [favoriteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: locationPhotoImageView.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        guard let location = self.location,
            let user = UserController.shared.currentUser else { return }
        if !user.favoritesID.contains(location.id) {
            if user.isAppleUser == true {
                UserController.shared.addFavoriteToAppleUserFavorites(business: location)
                favoriteButton.setBackgroundImage(UIImage(named: "filledHeart"), for: .normal)
            } else {
                UserController.shared.addFavoriteToUserFavorites(business: location)
                favoriteButton.setBackgroundImage(UIImage(named: "filledHeart"), for: .normal)
            }
            favoriteSavedToFavoritesAlert()
            print("added to favorites")
            
        } else {
            if user.isAppleUser == true {
                UserController.shared.deleteFavoriteFromAppleUser(business: location)
                favoriteButton.setBackgroundImage(UIImage(named: "unFilledHeart"), for: .normal)
                FavoriteCollectionViewController().reloadInputViews()
            } else {
                
                UserController.shared.deleteFavoriteFromUser(business: location)
                favoriteButton.setBackgroundImage(UIImage(named: "unFilledHeart"), for: .normal)
                FavoriteCollectionViewController().reloadInputViews()
            }
            removedFromFavoritesAlert()
            print("removed from favorites")
        }
        print("Button tapped")
    }
    
    func favoriteSavedToFavoritesAlert() {
        let alert = UIAlertController(title: "Favorite has been added to your favorites", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated:  true)
    }
    
    func removedFromFavoritesAlert() {
        let alert = UIAlertController(title: "This has been removed from your favorites", message: "Please allow some time for the network to update and the deleated location to disipear", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated:  true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentVC" {
            let destinationVC = segue.destination as? CommentViewController
            destinationVC?.businessID = self.location?.id
        }
    }
}

protocol LocationDetailViewControllerDelegate: class {
    func removeFavoriteToUpdateView() 
}
