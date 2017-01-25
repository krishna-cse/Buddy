//
//  PostCell.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/13/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var hugCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hugButton: UIButton!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
