//
//  CommentViewController.swift
//  TourMore
//
//  Created by Josh Sparks on 11/26/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentViewController: UIViewController {
    
    
    @IBOutlet weak var enterCommentTextView: UITextView!
    
    @IBOutlet weak var commentListTableView: UITableView!
    
    var ref: DatabaseReference?
    
    var commentData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        commentListTableView.delegate = self
//        commentListTableView.dataSource = self
//
        // Set the firebase reference
        ref = Database.database().reference()
        
        // Retrieve the comments and listen for changes
        ref?.child("comment").child("text").observe(.childAdded, with: { (snapshot) in
            // Code to execute when a child is added under "Comment"
            
        })
    }
    
    @IBAction func addComment(_ sender: Any) {
        // Post the data to firebase
        ref?.child("comment").child("text").childByAutoId().setValue(enterCommentTextView.text)
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

//
//extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        commentData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
