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
    //@IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var memberNameTextField: UITextField!
    
    //var delete = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    @IBAction func deleteButtonPressed(_ sender: UIButton) {
//        delete = true
//        print("delete state is true now")
//
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
