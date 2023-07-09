//
//  GroupTableViewCell.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import UIKit
import SwipeCellKit

class GroupMemberTableViewCell: UITableViewCell {
    
    static var id = "GroupMemberTableViewCell"
    @IBOutlet weak var memberNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TextFieldManager : Comparable {
    
    let time: Date
    
    init(time: Date) {
        self.time = time
    }
    
    static func < (lhs: TextFieldManager, rhs: TextFieldManager) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func == (lhs: TextFieldManager, rhs: TextFieldManager) -> Bool {
        return true
    }
}
