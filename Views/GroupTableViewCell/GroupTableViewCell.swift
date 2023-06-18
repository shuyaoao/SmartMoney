//
//  GroupTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import UIKit
import SwipeCellKit

class GroupTableViewCell: SwipeTableViewCell {
    
    @IBOutlet var amtLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
