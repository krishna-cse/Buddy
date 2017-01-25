//
//  accountUserCustomCell.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/18/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class accountUserCustomCell: UITableViewCell {

    @IBOutlet var raceLabel: UILabel!
    @IBOutlet var sexualityLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
