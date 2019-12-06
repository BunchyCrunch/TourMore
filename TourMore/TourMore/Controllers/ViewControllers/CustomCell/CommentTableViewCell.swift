//
//  CommentTableViewCell.swift
//  TourMore
//
//  Created by Josh Sparks on 12/4/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//
import UIKit
class CommentTableViewCell: UITableViewCell {
    var comment: Comment? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var commentTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let comment = comment else { return }
        commentTextLabel.text = comment.text
    }
} // end of class
