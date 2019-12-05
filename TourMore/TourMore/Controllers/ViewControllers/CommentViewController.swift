//
//  CommentViewController.swift
//  TourMore
//
//  Created by Josh Sparks on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var enterCommentTextView: UITextView!
    
    @IBOutlet weak var commentListTableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var ref: DatabaseReference?
   
    
    var businessID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentListTableView.delegate = self
        commentListTableView.dataSource = self

        // Set the firebase reference
        ref = Database.database().reference()
    }
    
    @IBAction func saveComment(_ sender: Any) {
        // Post the data to firebase
        guard let text = enterCommentTextView.text, let businessID = businessID else { return }
        let rating = 0
        CommentController.shared.addComment(to: businessID, text: text, rating: rating) { (success) in
            if success {
                // reload table
                self.commentListTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CommentController.shared.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentListTableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentTableViewCell else { return UITableViewCell()}
        
        let comment = CommentController.shared.comments[indexPath.row]
        cell.comment = comment
        
        return cell
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
