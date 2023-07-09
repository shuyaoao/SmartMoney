//
//  GroupExpensesTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit
import SwipeCellKit

class GroupExpensesTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var whoPaidLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var whoOwedLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var involvedLabel: UILabel!
    @IBOutlet weak var payUpLabel: UILabel!
    @IBOutlet weak var dateLabelForPayup: UILabel!
    weak var expense: GroupExpense?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ expense: GroupExpense) {
        self.expense = expense
        if expense.description != "Payup" {
            self.dateLabelForPayup.isHidden = true
            self.dateLabel.isHidden = false
            self.payUpLabel.isHidden = true
            self.involvedLabel.isHidden = false
            self.whoOwedLabel.isHidden = false
            self.amountLabel.isHidden = false
            self.categoryImage.isHidden = false
            self.categoryImage.image = UIImage(systemName: expense.category.imageName)
            self.categoryImage.tintColor = UIColor(named: "Off-white")
            self.descriptionLabel.isHidden = false
            self.whoOwedLabel.isHidden = false
            self.amountLabel.isHidden = false
            self.whoPaidLabel.isHidden = false
            self.whoOwedLabel.text = String(format: "$%.2f", expense.splits.first(where: { split in
                split.user.id == myself.id
            })?.amount ?? 0)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            self.dateLabel.text = formatter.string(from: expense.date)
            self.descriptionLabel.text = expense.description
            self.whoPaidLabel.text = String(format: "%@ paid $%.2f", expense.payer.name, expense.amount)
            let myOwes = expense.splits.first(where: { split in
                split.user.id == myself.id
            })?.amount ?? 0
            if expense.payer.name != myself.name && myOwes >= 0 {
                if myOwes > 0  {
                    self.involvedLabel.isHidden = true
                    self.whoOwedLabel.isHidden = false
                    self.amountLabel.isHidden = false
                    self.whoOwedLabel.text = "You owe:"
                    self.whoOwedLabel.textColor = UIColor.red
                    self.amountLabel.text = String(format: "$%.2f", myOwes)
                    self.amountLabel.textColor = UIColor.red
                } else {
                    self.involvedLabel.isHidden = false
                    self.whoOwedLabel.isHidden = true
                    self.amountLabel.isHidden = true
                }
            } else {
                self.involvedLabel.isHidden = true
                self.whoOwedLabel.isHidden = false
                self.amountLabel.isHidden = false
                self.whoOwedLabel.text = "You are owed:"
                self.amountLabel.text = String(format: "$%.2f", expense.amount - myOwes)
                self.whoOwedLabel.textColor = UIColor(named: "green")
                self.amountLabel.textColor = UIColor(named: "green")
            }
        } else {
            self.dateLabelForPayup.isHidden = false
            self.dateLabel.isHidden = true
            self.payUpLabel.isHidden = false
            self.involvedLabel.isHidden = true
            self.whoOwedLabel.isHidden = true
            self.amountLabel.isHidden = true
            self.categoryImage.isHidden = true
            self.descriptionLabel.isHidden = true
            self.whoOwedLabel.isHidden = true
            self.amountLabel.isHidden = true
            self.whoPaidLabel.isHidden = true
            self.payUpLabel.text = String(format: "%@ paid %@ $%.2f", expense.payer.name, expense.splits[0].user.name, expense.amount)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            self.dateLabelForPayup.text = formatter.string(from: expense.date)
        }
    }
}
