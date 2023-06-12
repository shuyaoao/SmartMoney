//
//  PayUpTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 12/6/23.
//

import UIKit

class PayUpTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rectangleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PayUpCell", bundle: nil)
    }
    
    public func configure(_ name: String) {
        nameLabel!.text = name
        self.rectangleView.layer.cornerRadius = 9
        self.rectangleView.layer.masksToBounds = true
    }
}
