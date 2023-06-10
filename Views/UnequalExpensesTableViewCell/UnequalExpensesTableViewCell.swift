//
//  UnequalExpensesTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import UIKit

class UnequalExpensesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    //@IBOutlet weak var nameLabel: UILabel!
    static var id = "UnequalExpensesCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UnequalExpensesCell", bundle: nil)
    }
    
    func configure(_ name: String) {
        self.nameLabel.text = name
    }
}
