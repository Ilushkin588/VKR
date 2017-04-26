//
//  MoreInfoTableViewCell.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 13.04.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit

class MoreInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var dateAndDayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var cardOrCashImageView: UIImageView!
    
    @IBOutlet weak var emojiImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
