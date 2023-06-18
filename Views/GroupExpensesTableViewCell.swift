//
//  GroupExpensesTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit

class GroupExpensesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whoPaidLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ expense: GroupExpense) {
        self.amountLabel.text = String(format: "$%.2f", expense.splits.first(where: { split in
            split.user.name == "Shuyao"
        })?.amount ?? 0.00)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        self.dateLabel.text = formatter.string(from: expense.date)
        //self.categoryImage.image = UIImage(named: "fork.knife")
        self.descriptionLabel.text = expense.description
        self.whoPaidLabel.text = String(format: "%@ paid $%.2f", expense.payer.name, expense.amount)
        let myOwes = expense.splits.first(where: { split in
            split.user.name == "Shuyao"
        })?.amount ?? 0
        if expense.payer.name != "Shuyao" && myOwes >= 0 {
            self.amountLabel.text = String(format: "You owe: $%.2f", myOwes)
        } else {
            self.amountLabel.text = String(format: "You are owed $%.2f", expense.amount - myOwes)
        }
    }

}
