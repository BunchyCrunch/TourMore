//
//  CommentTableViewCell.swift
//  TourMore
//
//  Created by Josh Sparks on 12/4/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//
import UIKit

protocol CommentTableViewCellDelegate {
    func actionButtonTapped(_ sender: CommentTableViewCell)
}

class CommentTableViewCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            updateViews()
        }
    }
    var delegate: CommentTableViewCellDelegate?
    
    @IBOutlet weak var commentTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func blockedButtonTapped(_ sender: Any) {
            // 1
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // 2
            let reportCommentAction = UIAlertAction(title: "Report Comment", style: .default) { (_) in
                self.delegate?.actionButtonTapped(self)
                //HIDE COMMENT FOR USER && SEND EMAIL TO FIREBASE EMAIL FOR REVIEW OF COMMENT
            }
            let blockCommentAction = UIAlertAction(title: "Block", style: .default) { (_) in
            }
            // 3
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            // 4
            optionMenu.addAction(reportCommentAction)
            optionMenu.addAction(blockCommentAction)
            optionMenu.addAction(cancelAction)
            // 5
//            self.present(optionMenu, animated: true, completion: nil)
        }
    
    func updateViews() {
        guard let comment = comment else { return }
        commentTextLabel.text = comment.text
    }
} // end of class
