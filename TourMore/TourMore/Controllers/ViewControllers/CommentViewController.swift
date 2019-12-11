//
//  CommentViewController.swift
//  TourMore
//
//  Created by Josh Sparks on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    @IBOutlet weak var enterCommentTextView: UITextView!
    
    @IBOutlet weak var commentListTableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var starOneButton: UIButton!
    @IBOutlet weak var starTwoButton: UIButton!
    @IBOutlet weak var starThreeButton: UIButton!
    @IBOutlet weak var starFourButton: UIButton!
    @IBOutlet weak var starFiveButton: UIButton!
    @IBOutlet weak var slideBar: UIView!
    
    
    var ref: DatabaseReference?
    var businessID: String?
    var businessComments: [Comment] = []
    
    var blockedCommentIDs: [String] = []
    
    var rating: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentListTableView.delegate = self
        commentListTableView.dataSource = self
        enterCommentTextView.delegate = self
        
        // Set the firebase reference
        guard let businessID = businessID else {return}
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        CommentController.shared.fetchCommentsForLocation(business: businessID) { (comments) in
            if let comments = comments {
                self.businessComments = comments
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        UserController.shared.fetchBlockedCommentsForAppleUser { (blockedIDs) in
            self.blockedCommentIDs = blockedIDs ?? []
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.setupViews()
            self.commentListTableView.reloadData()
        }
    }
    
    func setupViews() {
        slideBar.layer.cornerRadius = 5
        enterCommentTextView.layer.borderWidth = 0.5
        enterCommentTextView.layer.borderColor = UIColor.black.cgColor
        enterCommentTextView.text = "Enter comment"
        enterCommentTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        doesUserExist()
    }
    
    func doesUserExist() {
        if Auth.auth().currentUser == nil {
            needToLogInAlert()
        } else {
            saveComment()
        }
    }
    func saveComment() {
        // Post the data to firebase
        guard let text = enterCommentTextView.text, !text.isEmpty,
            let businessID = self.businessID else { return }
        // let businessID = businessID
        CommentController.shared.addComment(text: text, rating: rating, businessID: businessID) { (comment, error) in
            if let comment = comment {
                guard let user = UserController.shared.currentUser else {return}
                if user.isAppleUser == true {
                    UserController.shared.postCommmentForAppleUser(comment: comment)
                } else if user.isAppleUser == false {
                    UserController.shared.postCommmentForUser(comment: comment)
                }
                
                self.starOneButton.setImage((UIImage(systemName: "star")), for: .normal)
                self.starTwoButton.setImage((UIImage(systemName: "star")), for: .normal)
                self.starThreeButton.setImage((UIImage(systemName: "star")), for: .normal)
                self.starFourButton.setImage((UIImage(systemName: "star")), for: .normal)
                self.starFiveButton.setImage((UIImage(systemName: "star")), for: .normal)
                
                self.enterCommentTextView.text = ""
                
                // reload table
                CommentController.shared.fetchCommentsForLocation(business: businessID) { (comments) in
                    if let comments = comments {
                        self.businessComments = comments
                    }
                }
                self.commentListTableView.reloadData()
            }
        }
    }
    
    
    func needToLogInAlert() {
        let needToLogin = UIAlertController(title: "You need to login to save a comment", message: nil, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        needToLogin.addAction(okayButton)
        self.present(needToLogin, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businessComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentListTableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentTableViewCell else { return UITableViewCell()}
        let comment = businessComments[indexPath.row]
        cell.comment = comment
        cell.delegate = self
        cell.updateViews()
        if blockedCommentIDs.contains(comment.id) {
            cell.changeBlockedCommentText()
        }
        return cell
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if enterCommentTextView.textColor == UIColor.lightGray {
            enterCommentTextView.text = nil
            enterCommentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if enterCommentTextView.text.isEmpty {
            enterCommentTextView.text = "Enter comment"
            enterCommentTextView.textColor = UIColor.lightGray
        }
    }
    
    func blockCommentForUser(comment: Comment?) {
        guard let commentToBlock = comment,
         let user = UserController.shared.currentUser else {return}
        if !user.blockedCommentIDs.contains(commentToBlock.id) {
            if user.isAppleUser == true {
                UserController.shared.blockCommentForAppleUser(blockedComment: commentToBlock)
            } else {
                UserController.shared.blockCommentForUser(blockedComment: commentToBlock)
            }
        }
    }
    
    @IBAction func starOneButtonPressed(_ sender: Any) {
        rating = 1
        starOneButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starTwoButton.setImage((UIImage(systemName: "star")), for: .normal)
        starThreeButton.setImage((UIImage(systemName: "star")), for: .normal)
        starFourButton.setImage((UIImage(systemName: "star")), for: .normal)
        starFiveButton.setImage((UIImage(systemName: "star")), for: .normal)
    }
    
    @IBAction func starTwoButtonPressed(_ sender: Any) {
        rating = 2
        starOneButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starTwoButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starThreeButton.setImage((UIImage(systemName: "star")), for: .normal)
        starFourButton.setImage((UIImage(systemName: "star")), for: .normal)
        starFiveButton.setImage((UIImage(systemName: "star")), for: .normal)
    }
    
    @IBAction func starThreeButtonPressed(_ sender: Any) {
        rating = 3
        starOneButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starTwoButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starThreeButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starFourButton.setImage((UIImage(systemName: "star")), for: .normal)
        starFiveButton.setImage((UIImage(systemName: "star")), for: .normal)
    }
    @IBAction func starFourButtonPressed(_ sender: Any) {
        rating = 4
        starOneButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starTwoButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starThreeButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starFourButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starFiveButton.setImage((UIImage(systemName: "star")), for: .normal)
    }
    
    @IBAction func starFiveButtonPressed(_ sender: Any) {
        rating = 5
        starOneButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starTwoButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starThreeButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starFourButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
        starFiveButton.setImage((UIImage(systemName: "star.fill")), for: .normal)
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func actionButtonTapped(_ sender: CommentTableViewCell) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 2
        let reportCommentAction = UIAlertAction(title: "Report Comment", style: .default) { (_) in
            //HIDE COMMENT FOR USER && SEND EMAIL TO FIREBASE EMAIL FOR REVIEW OF COMMENT
        }
        let blockCommentAction = UIAlertAction(title: "Block", style: .default) { (_) in
            self.blockCommentForUser(comment: sender.comment)
            sender.commentTextLabel.text = "BLOCKED COMMENT"
            sender.commentTextLabel.textColor = .red
        }
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // 4
        optionMenu.addAction(reportCommentAction)
        optionMenu.addAction(blockCommentAction)
        optionMenu.addAction(cancelAction)
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }
}
